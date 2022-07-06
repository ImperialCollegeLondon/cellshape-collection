function [mask] = makeNucleusMask(volume, defaultThresh, Settings, acMethod)
    mask = thresholdMask(volume, defaultThresh, Settings.minVolumeNucleus);
    switch acMethod
        case 'full'
            mask = activecontour(volume,mask,Settings.nIterationsNucleus);
            mask = bwareaopen(mask, ceil(Settings.minVolumeNucleus));
        case 'subROI'
            tic
            mask = activecontourSUBROI(volume,mask, Settings.nIterationsNucleus, 'Chan-Vese');
            toc
            mask = bwareaopen(mask, ceil(Settings.minVolumeNucleus));
        otherwise
            % do nothing
    end  
    mask = watershedNucleus(volume, mask, Settings);
    mask = bwareaopen(mask, ceil(Settings.minVolumeNucleus));
    mask = imclearborder(mask,26);
end

function [finalMaskedImage] = watershedNucleus(volume, mask, Settings)
    
    ConnectedComponents = bwconncomp(mask);
    Stats = regionprops3(ConnectedComponents,'SubarrayIdx', 'VoxelIdxList');


    parfor iRoi = 1:size(Stats,1)   
    %     subVolume           = roiVolume(volume, Stats(iRoi,:));
        subMask             = roiVolume(mask, Stats(iRoi,:));
        maskedSubRoi{iRoi}  = watershed_bw_dist(subMask);
    end

    finalMaskedImage = uint16(zeros(size(mask)));

    for iRoi = 1:size(Stats,1) 
        finalMaskedImage(Stats(iRoi,:).SubarrayIdx{:}) = ...
            finalMaskedImage(Stats(iRoi,:).SubarrayIdx{:}) | maskedSubRoi{iRoi};
    %     sum(finalMaskedImage(:))
    end
end
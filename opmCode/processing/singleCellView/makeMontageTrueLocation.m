function [] = makeMontageTrueLocation(folder, listCells, Fullpath, gridWeight, nRuns, nChannels, cropOn)

volumeDims = (getDimensionsAllCells(listCells, folder)); % needed so all montages are the same size

if cropOn
    maxVolumeDims = max(volumeDims);
    meanDimension =  mean(volumeDims);
    croppedVolumeDims = ones(size(maxVolumeDims)) * max(meanDimension);
    cropBox = makeCropBox(ceil(croppedVolumeDims), maxVolumeDims);
else
    maxVolumeDims = max(volumeDims);
    cropBox = [];
end



savePath = [Fullpath.savepath '\orthoMaskMontage\' datestr(datetime('now'), 'yymmdd_HHMMSS')];
mkdirNC(savePath)
save([savePath '\cellList'], 'listCells')

savepathMip = [savePath '\individualMIP']
mkdirNC(savepathMip)

tic
parfor iRun = 1:116%nRuns; 
    for iChannel = 1:nChannels
        mip = makeAllCellMIPs(listCells, folder, iRun,...
            iChannel, maxVolumeDims,gridWeight, cropBox);
        montage = makeMontage(mip);
        SaveUIntTiff(montage,[savePath...
            '\run_' num2str(iRun, '%04d')... 
            '_channel_' num2str(iChannel, '%04d')...
            '.tif']); 
        %% only necessary to make point RE some cells being too big to allow a smaller box
%         for ii = 1:numel(mip)
%             SaveUIntTiff(mip{ii},[savepathMip...
%             '\run_' num2str(iRun, '%04d')... 
%             '_channel_' num2str(iChannel, '%04d')...
%             '_' listCells{ii}...
%             '.tif']); 
%         end
    end
end
toc

end

function [mip] = makeAllCellMIPs(listCells, folder, iRun, iChannel, volumeDims,gridWeight, cropBox)
    for iCell = 1:numel(listCells)
        volume = loadAndPadVolume(folder, listCells, iCell, iRun, iChannel, volumeDims);
        if ~isempty(cropBox)
            volume = volume(cropBox{:});
        end
        mip{iCell} = mipSegmented(volume, gridWeight);
    end 
end
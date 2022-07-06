function [watershedCellMask] = cellWatershed(cellMask, nucleusMask, Settings)
Stats = regionprops3(bwconncomp(cellMask),'SubarrayIdx','VoxelIdxList');
parfor i = 1:size(Stats.SubarrayIdx,1)
    nucleusMaskSubRegion    = nucleusMask(Stats(i,:).SubarrayIdx{:});
    cellMaskSubRegion{i}       = cellMask(Stats(i,:).SubarrayIdx{:});
    
    cellMaskSubRegion{i} = watershedCells(cellMaskSubRegion{i},...
        nucleusMaskSubRegion);
    cellMaskSubRegion{i} = bwareaopen(cellMaskSubRegion{i},...
        ceil(Settings.minVolume));
end

watershedCellMask = zeros(size(cellMask));
for iRoi = 1:size(cellMaskSubRegion,2)
    watershedCellMask(Stats(iRoi,:).SubarrayIdx{:}) = ...
        watershedCellMask(Stats(iRoi,:).SubarrayIdx{:}) | cellMaskSubRegion{iRoi};
end
end

function [overallSegmented] = watershedCells(cellMask, nucleusMask)
    %watershedCellSubregionFunction Function where the segmentation on smaller
    %volumes takes place

    %% Prime for watersheding, using nucleus separation
    % Background to infinity
    cellMask = single(cellMask);
    cellMask(cellMask==0)=inf;
    % Background nuclei to 0
    cellMask(nucleusMask==1)=0;
    %Watershed
    overallSegmented = watershed((cellMask));
    % Remove background
    overallSegmented(cellMask==inf)=0;
    overallSegmented(overallSegmented > 0) = 1;
end
function [cellMask] = getCellMask(cellVolume, nucleusMask, thresh,...
    Settings, activeContourMethod)
    cellMask = thresholdCellMask(cellVolume, thresh);
    cellMask = bwareaopen(cellMask, Settings.minVolume);
    switch activeContourMethod
        case  'full'
            cellMask = activecontour(cellVolume,cellMask,...
                Settings.nIterationsCell, Settings.type);
        case 'subROI'
            cellMask = activecontourSUBROI(cellVolume,cellMask,...
                Settings.nIterationsCell, Settings.type);
        otherwise 
    end    
    cellMask = formatCellMask(cellMask, nucleusMask, Settings, 0); % deliberately set active contour to zero here so we still do imclose etc.
    cellMask = rejectCellsWithoutNuclei(cellMask, nucleusMask);
    if sum(cellMask(:)) > 0 % if all elements are too small then don't bother watershedding
        cellMask = cellWatershed(cellMask, nucleusMask, Settings);
        cellMask = bwareaopen(cellMask, Settings.minVolume);
    end
    cellMask = imclearborder(cellMask,26);
end



function [cellMaskCombined] = formatCellMask(cellMask, nucleusMask, Settings, activecontour)
    cellMaskCombined = cellMask | nucleusMask;
    
    if ~activecontour
        strehlVolume = strel('sphere',Settings.strehlRadius);
        cellMaskCombined = imclose(cellMaskCombined, strehlVolume);
        cellMaskCombined = fill_holes3D(cellMaskCombined);
    end
    
%     if Settings.rejectNucleiOnlyCells
%         cellMaskCombined = rejectCellsWithoutNuclei(cellMaskCombined, cellMask); % reject cells which don't appear in the original cell mask (nuclei only)
%     end
    
    cellMaskCombined = bwareaopen(cellMaskCombined, ceil(Settings.minVolume));
end


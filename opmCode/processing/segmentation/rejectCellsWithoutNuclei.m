function [cellMask] = rejectCellsWithoutNuclei(cellMask, nucleusMask)
    ConnectedComponents = bwconncomp(nucleusMask); % needed to get stats for all elements (found empirically)
    nucleusList = regionprops3(ConnectedComponents,'Centroid');
    for i=1:numel(nucleusList)
        nucleusLocations(i) = sub2ind(size(nucleusMask),...
            round(nucleusList.Centroid(i,2)), ...
            round(nucleusList.Centroid(i,1)), ...
            round(nucleusList.Centroid(i,3)));
    end
    % check nuclei are in cell mask, reject those which aren't
    cellVoxels = regionprops3(bwconncomp(cellMask),'VoxelIdxList');
    for i = 1:numel(cellVoxels)
        test=ismember(cellVoxels.VoxelIdxList{i},nucleusLocations);
        if max(test) == 0
            cellMask(cellVoxels.VoxelIdxList{i}) = 0;
        end
    end
end
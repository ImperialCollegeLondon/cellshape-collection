function [singleCluster, cellsToShow] = getRandomClusterCells(clusterTable, clusterList, iCluster, nCellsToDisplay)
    % reduce cluster data to just one cluster
    singleCluster = getSingleCellStat(clusterTable, clusterList(iCluster), 'cluster');

    % choose random subset of cells
    cellsToShow = ...%[1: min([nCellsToDisplay, size(singleCluster,1)])]
            randperm(size(singleCluster,1),...
            min([nCellsToDisplay, size(singleCluster,1)]));
    if numel(cellsToShow) > 0 % pad so get correct number of cells
        cellsToShow = padarray(cellsToShow,[0, nCellsToDisplay - numel(cellsToShow)],0,'post');
    else % make with zeros so still correct size
        cellsToShow = zeros(nCellsToDisplay, 1);
    end
end

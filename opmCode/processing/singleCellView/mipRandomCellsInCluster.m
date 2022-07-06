function [mip, cellShown] = mipRandomCellsInCluster(clusterTable,...
    clusterList, iCluster, nCellsToDisplay, fp, boxSize, nChannels, gridWeight, translateOn)

% select random subset of cells in cluster
    [singleCluster, cellsToShow] = getRandomClusterCells(clusterTable, clusterList, iCluster, nCellsToDisplay);

    % make MIPs for each cell
    cellShown = []; % keeps a record of cells used
    for iCell = 1:numel(cellsToShow)
        % get volume of cells (if there are any)
        if cellsToShow(iCell) > 0 % there is a cell to show
            singleCell = singleCluster(cellsToShow(iCell),:);
            Fullpath = fp{singleCell.Plate};
            [volume flag] = loadPaddedVolumeAllChannels(Fullpath, singleCell, boxSize, nChannels);
            if flag
                error('Image bigger than box')
            end
            
            if translateOn
                volume = centreOnNucleus(volume);
            end
            cellShown = [cellShown
                singleCell]; % keep record of which cells contributed        
        else % index of 0 means there is no cell (do not add to table, just make an empy mask
            for iChannel = 1:nChannels
                volume{iChannel} = zeros(boxSize, 'uint16');
            end
        end
        % make an MIP
        for iChannel = 1:numel(volume)
            mip{iChannel, iCell} = mipSegmented(volume{iChannel}, gridWeight);
        end
    end
    
end








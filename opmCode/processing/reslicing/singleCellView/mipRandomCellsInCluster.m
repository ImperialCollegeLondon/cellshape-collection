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

function [singleCluster, cellsToShow] = getRandomClusterCells(clusterTable, clusterList, iCluster, nCellsToDisplay)
    % reduce cluster data to just one cluster
    singleCluster = getSingleCellStat(clusterTable, clusterList(iCluster), 'cluster');

    % choose random subset of cells
    cellsToShow = randperm(size(singleCluster,1),...
            min([nCellsToDisplay, size(singleCluster,1)]));
    if numel(cellsToShow) > 0 % pad so get correct number of cells
        cellsToShow = padarray(cellsToShow,[0, nCellsToDisplay - numel(cellsToShow)],0,'post');
    else % make with zeros so still correct size
        cellsToShow = zeros(nCellsToDisplay, 1);
    end
end

function [volume, flag] = loadPaddedVolumeAllChannels(Fullpath, singleCell, boxSize,nChannels)
% loads and pads the volumes corresponding to a single cell
    croppedVolumePath = [upOneFolderLevel(Fullpath.savepath)...
        '\singleCellVolumes\' char(singleCell.serialNumber)];

    for iChannel = 1:nChannels;
        volume{iChannel} = loadSingleCellCroppedVolume(croppedVolumePath, singleCell, iChannel);
        if size(volume{iChannel}) <= boxSize % fine to continue
            volume{iChannel} = padToBoxSize(volume{iChannel}, boxSize);
            flag = 0;
        else
            flag = 1
        end
    end
end





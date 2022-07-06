function [volume, flag] = loadPaddedVolumeAllChannels(Fullpath, singleCell, boxSize,nChannels)
% loads and pads the volumes corresponding to a single cell
    croppedVolumePath = [upOneFolderLevel(Fullpath.savepath)...
        '\singleCellVolumesFiltered\' char(singleCell.serialNumber)]

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
function [volume] = loadAndPadVolume(folder, listCells, iCell, iRun, iChannel, volumeDims)
    volume = loadSingleCellVolume(folder,listCells, iCell, iRun, iChannel);
    volume = padToBoxSize(volume, volumeDims); 
end
function [matchedCell] = findCellInMatFile(croppedVolumePath, cellStats)
    fieldStats = load([croppedVolumePath '\field_' num2str(cellStats.fieldNumber ,'%04d') '.mat']);
    fieldStats = fieldStats.Stats;
    fieldStats = fieldStats{cellStats.runNumber};        
    matchedCell = fieldStats(strcmp(fieldStats.serialNumber, cellStats.serialNumber),:);
end
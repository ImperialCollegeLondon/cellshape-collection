function [snStats] = getSerialNumberStats(BigStatsTable, serialNumberList, iSN)
    Index = find(contains(BigStatsTable.serialNumber,serialNumberList{iSN}));
    snStats = BigStatsTable(Index,:);
end
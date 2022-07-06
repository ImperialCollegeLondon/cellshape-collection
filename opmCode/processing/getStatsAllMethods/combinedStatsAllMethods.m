function [CellStats, NucleusStats] = combinedStatsAllMethods(CellStats, NucleusStats)
for iRun = 1:size(CellStats,1)
    for iMethod = 1:size(CellStats,2)
        if ~isempty(CellStats{iRun,iMethod})
            [CellStats{iRun,iMethod}, NucleusStats{iRun,iMethod}] =...
                getCombinedStats(CellStats{iRun,iMethod}, NucleusStats{iRun,iMethod});
        end
    end
end
[CellStats] = dealWithEmptyCells(CellStats);
[NucleusStats] = dealWithEmptyCells(NucleusStats);
end
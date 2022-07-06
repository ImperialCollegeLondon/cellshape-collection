function [CellStats, MatchedNucleusStats] = trackCellsByTimeAndMethod(CellStats, NucleusStats,methodListCell)

for iMethod = 1:numel(methodListCell);
    parfor iRun = 1:size(CellStats,1)
        MatchedNucleusStats{iRun, iMethod} = matchCellToNucleus(...
            CellStats{iRun,iMethod}, NucleusStats{iRun}); 
    end
end

MatchedNucleusStats = trackNucleiByTimeAndMethod(MatchedNucleusStats, methodListCell);
for iRun = 1:size(CellStats,1)
    for iMethod = 1:size(CellStats,2)  
        if ~isempty(CellStats{iRun, iMethod})
            CellStats{iRun, iMethod} = addTracksToCells(...
                CellStats{iRun, iMethod}, MatchedNucleusStats{iRun, iMethod});
        end
    end
end

end

function [CellStats] = addTracksToCells(CellStats, NucleusStats)
CellStats.methodNumber = NucleusStats.methodNumber;
CellStats.methodTrack = NucleusStats.methodTrack;
CellStats.runNumber = NucleusStats.runNumber;
CellStats.timeTrack = NucleusStats.timeTrack;
end
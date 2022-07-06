function [CellStats, NucleusStats] = loadAndCleanStats(Fullpath, iField, Settings, methodListCell, nucleusMethodForSeeds)

load([upOneFolderLevel(Fullpath.savepath)  '\statsAllMethodsRuns' '\field_' num2str(iField, '%04d') '\statsAllMethods']);
%% clean up
CellStats = removeLowIntensityCells(CellStats, Settings.minCellIntensity);
[CellStats, NucleusStats] = trackCellsByTimeAndMethod(CellStats,...
    NucleusStats(:,nucleusMethodForSeeds),methodListCell);
% add stats which are derived from cell and nucleus stats
[CellStats, NucleusStats] =...
    combinedStatsAllMethods(CellStats, NucleusStats);

%% Remove cells which occur with low frequency
CellStats       = removeShortTracks(CellStats, Settings.minFractionPresent);
NucleusStats    = removeShortTracks(NucleusStats, Settings.minFractionPresent);

end
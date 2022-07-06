function [Stats] = addSerialNumber(Stats, iField, rawPath)
    nRuns = numel(Stats);
    for iRun = 1:nRuns
        runStats = Stats{iRun};
        temp = [];
        for iCell = 1:size(runStats,1)
           temp{iCell} = [num2str(iField, '%04d') '_' ...
               num2str(runStats(iCell,:).timeTrack, '%04d') '_'...
                strrep(rawPath, '\', '_')];
        end
        runStats.serialNumber = temp';
        Stats{iRun} = runStats;
    end
end
function [] = plotAverageCell(BigStatsTable, methodList, metric, iField, cellOrNucleus, Fullpath)

hold all
for iMethod = 1:numel(methodList)
    MethodStats = getSingleCellStat(BigStatsTable, iMethod, 'methodNumber');
    for iRun = 1:max(BigStatsTable.runNumber)
        RunStats = getSingleCellStat(MethodStats, iRun, 'runNumber');
        timeVolume(iMethod, iRun) = mean(getfield(RunStats, metric));        
    end
    plot(timeVolume(iMethod,:), '-o')
end
legend(methodList)
xlabel('time point')
ylabel(['Mean ' metric])
box on
savepath = [Fullpath.savepath '\field_' num2str(iField, '%04d') '\' cellOrNucleus];
mkdirNC(savepath)
saveas(gcf,[savepath '\meanVolume.png'])
end
function [Stats] = getStatsAllMethods(methodList,mask,volume, FullpathStats, cellOrNucleus,iField, iRun)

    for iMethod = 1:numel(methodList)
        Stats{iMethod} = getStats(mask{iMethod},volume);
        if ~isempty(Stats{iMethod})
            Stats{iMethod} = getExtraStats(Stats{iMethod});
        end
        savepath = [FullpathStats.savepath '\' cellOrNucleus '_' methodList{iMethod}...
                '\field_' num2str(iField, '%04d') ];
        mkdirNC(savepath)
        saveStats(Stats{iMethod}, savepath, iRun)
    end
    
end



function [] = saveStats(Stats, savepath, iRun)
    save([savepath '\run_' num2str(iRun, '%04d')], 'Stats');
end
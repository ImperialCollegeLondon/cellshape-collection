function [CellStats] = segmentCellAllMethods(Fullpath, FullpathStats, Settings, iField,...
    NucleusStats, chosenNucleusMethod, methodListCell, methodListNucleus, nRuns)

cellOrNucleus = 'cell';

%% Get thresholds
parfor iRun = 1:nRuns
    wellTable(iRun,:) = getListOfThresholds(Fullpath, Settings, iField, iRun, 'cell'); 
end

cellThreshold.activeContour                 = Settings.acThresholdCell;
cellThreshold.oneLevelOtsu.vary             = wellTable.level_1;
cellThreshold.oneLevelOtsu.average          = mean(wellTable.level_1);
cellThreshold.twoLevelOtsu.vary             = wellTable.level_2_take_1;
cellThreshold.twoLevelOtsu.average          = mean(wellTable.level_2_take_1);
cellThreshold.subROIac                      = wellTable.subROIac;




%% 

for iRun = 1:nRuns
    tic
%% Get cell volume and nucleus mask
volume = prepareAndLoadCroppedVolume(Fullpath, Settings,...
    iField, iRun, false);
nucleusMask = regenerateNucleusMask(NucleusStats{iRun,chosenNucleusMethod}, Fullpath, iField, iRun);

savepath = [Fullpath.savepath '\' cellOrNucleus '\field_' num2str(iField, '%04d')...
    '\run_' num2str(iRun, '%04d')];
mkdirNC(savepath)
saveTiffStack(savepath,volume)
%% Do segmentation
tic
cellMask = segmentCellsAllMethods(methodListCell, cellThreshold,iRun, volume,...
    nucleusMask, Settings, Fullpath, cellOrNucleus, iField);
toc


%% Get stats
CellStats(iRun,:) = getStatsAllMethods(methodListCell,cellMask,volume, FullpathStats, cellOrNucleus,iField, iRun);
toc
end

savePath = [upOneFolderLevel(Fullpath.savepath)  '\statsAllMethodsRuns' '\field_' num2str(iField, '%04d')];
mkdirNC(savePath)
save([savePath '\statsAllMethods'],...
    'CellStats',...
    'NucleusStats', ...
    'methodListCell', ...
    'methodListNucleus',...
    'Settings', ...
    'cellThreshold', ...
    'cellOrNucleus', ...
    'chosenNucleusMethod',...
    '-v7.3' ...
    )

end



function [threshold, activeContourMethod] = setThreshold(method,...
        cellThreshold, iRun)
    switch method
        case 'activeContour'
            threshold = cellThreshold.activeContour;
            activeContourMethod = 'full';
        case 'oneLevelOtsu_byTimePoint'
            threshold = cellThreshold.oneLevelOtsu.vary(iRun);
            activeContourMethod = false;
        case 'twoLevelOtsu_byTimePoint'
            threshold = cellThreshold.twoLevelOtsu.vary(iRun);
            activeContourMethod = false;
        case 'oneLevelOtsu_timeAverage'
            threshold = cellThreshold.oneLevelOtsu.average;
            activeContourMethod = false;
        case 'twoLevelOtsu_timeAverage'
            threshold = cellThreshold.twoLevelOtsu.average;
            activeContourMethod = false;            
        case 'subROIac'
            threshold = cellThreshold.subROIac;
            activeContourMethod = 'subROI';            
        otherwise
            error('method not found')
    end
end

function [cellMask] = segmentCellsAllMethods(methodList, cellThreshold,...
        iRun, volume, nucleusMask, Settings, Fullpath, cellOrNucleus, iField)
    for iMethod = 1:numel(methodList)
        [threshold, activeContourMethod] = setThreshold(methodList{iMethod},...
            cellThreshold, iRun);
        % what to do if there are no nuclei
        if sum(nucleusMask(:)) > 0 % some nuclei in mask
            cellMask{iMethod} = getCellMask(volume, nucleusMask, threshold, Settings,...
                activeContourMethod);
        else
            cellMask{iMethod} = nucleusMask; % this is empty
        end
        savepath = [Fullpath.savepath '\' cellOrNucleus '_mask_' methodList{iMethod}...
        '\field_' num2str(iField, '%04d') '\run_' num2str(iRun, '%04d')];
        mkdirNC(savepath)
        saveTiffStack(savepath,cellMask{iMethod}) 
    end 
end


function [NucleusStats, volumeDims] = segmentNucleusAllMethods(Fullpath, FullpathStats, methodList, threshold, Settings, iField, nRuns)

%% Get table of all thresholds
cellOrNucleus = 'nucleus';
for iRun = 1%:nRuns
    wellTable(iRun,:) = getListOfThresholds(Fullpath, Settings, iField, iRun, cellOrNucleus); 
end

threshold.manualThreshold   = mean(wellTable.level_1);
threshold.subROIac   = NaN; % calculated later
threshold.activeContour_adaptThreshold   = NaN; % calculated later

%% Load volume
N = numel(methodList) 
NucleusStats = cell(nRuns, numel(methodList));
t = tic;
for iRun = 1:nRuns
    tic
    [volume, cellOrNucleus] = prepareAndLoadCroppedVolume(Fullpath, Settings,...
        iField, iRun, true);

    %% Segment volume
    [mask] = getMaskForAllMethods(methodList, volume, cellOrNucleus,...
        Fullpath, Settings,iField, iRun, threshold);

    %% Get stats
    NucleusStats(iRun,:) = getStatsAllMethods(methodList,mask,volume, FullpathStats, cellOrNucleus,iField, iRun);
    volumeDims{iRun} = size(volume);
    toc
end
volumeDims = volumeDims{1}; % done outside of loop to avoid parfor issues
% toc
savePath = [upOneFolderLevel(Fullpath.savepath)  '\statsAllMethodsRuns' '\field_' num2str(iField, '%04d')];
mkdirNC(savePath)

save([savePath '\statsAllMethods'],...
    'NucleusStats', 'methodList', 'Settings', 'threshold', 'cellOrNucleus')
time.maskAndStats = toc(t);
end


function [mask] = getMaskForAllMethods(methodList, volume, cellOrNucleus, Fullpath, Settings,iField, iRun, threshold)
    for iMethod = 1:numel(methodList)
        mask{iMethod} = segmentNuclues(volume, cellOrNucleus, Fullpath,...
            Settings,iField, iRun, methodList{iMethod},...
            getfield(threshold, methodList{iMethod}));
    end
end
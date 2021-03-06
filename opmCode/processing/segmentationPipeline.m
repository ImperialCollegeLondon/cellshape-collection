close all
clear

rawOnRDS = 0;
terminal7 = 4;
rawPath = 'accelerator\20210318_bakal02_erk\main\21-03-18\11-20-14';

Settings = getSettings();
Settings.cst = 4;
% Settings.nIterations = 500;
defaultThresh = 23.59;
savingOn = true;
saveMIP_on = true;

% channel Settings
Settings.singleCamera = true;

Settings.markerChannel = [642];
Settings.cellChannel = [488];
Settings.markerChannel = 'exc642_filter731';
Settings.cellChannel = 'exc488_filter525';


% cell settings
Settings.strehlRadius = 2;
Settings.minVolume = 512;
Settings.fixedThreshold = 20;
Settings.nIterationsCell = 100;
Settings.nIterationsNucleus = 100;
Settings.type = 'Chan-Vese';
Settings.acThresholdCell = 1;
Settings.minBranchLength = 10;

nucleusThreshold.activeContour          = 1;
nucleusThreshold.oneLevelOtsu           = [];

% remove "bad cells"
Settings.minFractionPresent = 0%0.5; % set to zero to retain all cells
Settings.minCellIntensity = 10; % reject nucleiu which do not have cells associated with them based on having low cell channel intesnity (set to -INF to keep all cells)
Settings.normaliseIntensity = 1;
%% Setting up
pathList = {'./fileHandling',...
    './prepareAndLoadCroppedVolume',...
    './cropping',...
    './segmentation',...
    './getStatsAllMethods',...
    './trackingCode',...
    './tableWork',...
    './singleCellView'};


%     './getOtsuThreshold',...
%     './beehivePlot',...
addToPath(pathList)
Fullpath = setFullpath(rawPath, terminal7, rawOnRDS, '\subROI\mask', ['\cst' num2str(Settings.cst)]);
FullpathStats = setFullpath(rawPath, terminal7, rawOnRDS, '\subROI\stats', ['\cst' num2str(Settings.cst)]);

%% Select method
methodListNucleus = {
%     'manualThreshold'
%     'oneLevelOtsu'
%     'activeContour'
    'subROIac'
%     'activeContour_adaptThreshold'
    };

if numel(methodListNucleus) == 1
    nucleusMethodForSeeds = 1; % 1 if only one method otherwise position of method in method list, used for markers in cell segmentation
else
    nucleusMethodForSeeds = 1; % select index from list
end

methodListCell = {
%     'oneLevelOtsu_byTimePoint'
%     'oneLevelOtsu_timeAverage'
%     'twoLevelOtsu_byTimePoint'
%     'twoLevelOtsu_timeAverage'
%     'activeContour'
    'subROIac'
    };

if numel(methodListCell) == 1
    cellMethod = 1; % 1 if only one method otherwise position of method in method list, used for markers in cell segmentation
else
    cellMethod = 1; % select index from list
end
%%
for iField  = [1:150]
    nRuns = 1;

    %% Nucleus stats
    [NucleusStats, volumeDims] = segmentNucleusAllMethods(Fullpath, FullpathStats, methodListNucleus, nucleusThreshold, Settings, iField, nRuns);

    %% Cell stats
    % load nucleus stats
    load([upOneFolderLevel(Fullpath.savepath) '\statsAllMethodsRuns' '\field_' num2str(iField, '%04d') '\statsAllMethods'])
    [CellStats] = segmentCellAllMethods(Fullpath, FullpathStats, Settings, iField,...
        NucleusStats, nucleusMethodForSeeds, methodListCell, methodListNucleus, nRuns);


    %% Combine cell and nucleus stats and track by nucleus CoM
    load([upOneFolderLevel(Fullpath.savepath)  '\statsAllMethodsRuns' '\field_' num2str(iField, '%04d') '\statsAllMethods']);
%     CellStats = removeLowIntensityCells(CellStats, Settings.minCellIntensity);
    [CellStats, NucleusStats] = trackCellsByTimeAndMethod(CellStats,...
        NucleusStats(:,nucleusMethodForSeeds),methodListCell);
    % add stats which are derived from cell and nucleus stats
    if max(cellfun(@numel, CellStats)) > 0
    [CellStats] = addBoxDimensions(CellStats);
    [NucleusStats] = addBoxDimensions(NucleusStats);
    [CellStats, NucleusStats] =...
        combinedStatsAllMethods(CellStats, NucleusStats);

    %% Remove cells which occur with low frequency
    CellStats       = removeShortTracks(CellStats, Settings.minFractionPresent);
    NucleusStats    = removeShortTracks(NucleusStats, Settings.minFractionPresent);
    end

    %% Save stats table
    CellStats = addSerialNumber(CellStats, iField, rawPath);
    NucleusStats = addSerialNumber(NucleusStats, iField, rawPath);
    
    parfor iRun = 1:numel(CellStats)
        CellStats{iRun} = countProtrusions(CellStats{iRun}, NucleusStats{iRun},...
            Settings.minBranchLength, volumeDims);
        NucleusStats{iRun} = countProtrusions(NucleusStats{iRun}, NucleusStats{iRun},...
            Settings.minBranchLength, volumeDims);
    end
    
    saveStats(CellStats, FullpathStats, 'cell', methodListCell, 1, iField);
    saveStats(NucleusStats, FullpathStats, 'nucleus', methodListNucleus, 1, iField);

    if max(cellfun(@numel, CellStats)) > 0
        makeSingleCellVolume(CellStats, NucleusStats, Fullpath, iField, cellMethod)
        %% Output cumulative masks along a track
%         gridWeight = 2;
%         cumulativeMIP = overlayMaskMIP(CellStats, NucleusStats, Fullpath,...
%             methodListCell, cellMethod, methodListNucleus, nucleusMethodForSeeds,...
%             gridWeight, iField);

%         %% Individual images of tracked cells
%         individualTrackCellImages('cell', NucleusStats, CellStats,...
%             Fullpath, iField, gridWeight, methodListNucleus, methodListCell, Settings.normaliseIntensity);
    %     montageOfChannelImages('cell', NucleusStats, Fullpath, iField);
%         individualTrackCellImages('nucleus', NucleusStats, CellStats,...
%             Fullpath, iField, gridWeight, methodListNucleus, methodListCell, Settings.normaliseIntensity);
    %     montageOfChannelImages('nucleus', NucleusStats, Fullpath, iField);
    end
end
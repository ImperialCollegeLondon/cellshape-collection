function [] =  makeSingleCellVolume(CellStats, NucleusStats, Fullpath, iField, iMethod)

BigStatsTable = vertcat(CellStats{:});
BigStatsTableNucleus = vertcat(NucleusStats{:});

nRuns = size(CellStats,1);
%%
% Need a list of cell serial numbers and the bounding box dimension that
% will get everything in that cells track
serialNumberList = unique(BigStatsTable.serialNumber);
for iSN = 1:numel(serialNumberList)
    snStats = getSerialNumberStats(BigStatsTable, serialNumberList, iSN);
%     boxSize{iSN} = getBiggestBox(snStats);
    boxIndex{iSN} = getTableArrayIndex(snStats);
end

% for debugging
% [Volume{1}, Volume{2}, Volume{3}] = loadRunVolumes(Fullpath, iField, 1, BigStatsTable, iMethod);
% [~, ~, Volume{4}] = loadRunVolumes(Fullpath, iField, 1, BigStatsTableNucleus, iMethod); % nucleus mask

%% Load run volumes and remake mask
tic
parfor iRun = 1:nRuns
    saveSubarrayVolumes(BigStatsTable, BigStatsTableNucleus, Fullpath, iField, iMethod, serialNumberList, boxIndex, iRun)
end
toc
end






function [nucleusVolume, cellVolume, maskVolume] = loadRunVolumes(Fullpath, iField, iRun, BigStatsTable, iMethod)
    path = [Fullpath.savepath '\' 'nucleus' '\field_' num2str(iField, '%04d') '\run_' num2str(iRun, '%04d')];
    nucleusVolume = readTiffStack(dir([path '\*.tif']));
    
    path = [Fullpath.savepath '\' 'cell' '\field_' num2str(iField, '%04d') '\run_' num2str(iRun, '%04d')];
    cellVolume = readTiffStack(dir([path '\*.tif']));    

   runMethodStats = getSingleCellStat(BigStatsTable, iRun, 'runNumber'); 
   runMethodStats = getSingleCellStat(runMethodStats, iMethod, 'methodNumber');
   maskVolume     = uint16(regenerateNucleusMask(runMethodStats, Fullpath, iField, iRun)) * 2^7;
end

function [] = saveSubarrayVolumes(BigStatsTable, BigStatsTableNucleus, Fullpath, iField, iMethod, serialNumberList, boxIndex, iRun)  
tic
[Volume{1}, Volume{2}, Volume{3}] = loadRunVolumes(Fullpath, iField, iRun, BigStatsTable, iMethod);
    [~, ~, Volume{4}] = loadRunVolumes(Fullpath, iField, iRun, BigStatsTableNucleus, iMethod); % nucleus mask
    for iSN = 1:numel(serialNumberList)
        saveCroppedVolumes(BigStatsTable, serialNumberList, iSN, Volume, boxIndex, Fullpath, iRun); % needs to be in a function so volumes not modified        
    end
    toc
end

function [] = saveCroppedVolumes(BigStatsTable, serialNumberList, iSN, Volume, boxIndex, Fullpath, iRun)
    snStats = getSerialNumberStats(BigStatsTable, serialNumberList, iSN);
    cellStats = getSingleCellStat(snStats, iRun, 'runNumber');
    subArrayIdx = boxIndex{iSN}; % uses bounding box which covers all cells
    if size(cellStats,1) == 1
        maskVolume = Volume{3};
        maskVolume(cellStats.VoxelIdxList{:}) = maskVolume(cellStats.VoxelIdxList{:}) * 2;
        Volume{3} = maskVolume;
        maskVolume = Volume{4};
        maskVolume(cellStats.VoxelIdxList{:}) = maskVolume(cellStats.VoxelIdxList{:}) * 2;
        Volume{4} = maskVolume;
    end
    %             case 0
    %                 % use the bounding box of the closest time point
    %                 [~,I] = min(abs(snStats.runNumber - iRun));
    %                 closestStats = snStats(I,:);
    %                 subArrayIdx = closestStats.SubarrayIdx;
    %             otherwise
    %                 error('too many cells with serial number')


    for iVolume = 1:numel(Volume)
        croppedVolume = cropVolume(Volume{iVolume}, subArrayIdx);
        savePath = [upOneFolderLevel(Fullpath.savepath) '\20210507singleCellVolumesFiltered\'...
            strrep(serialNumberList{iSN}, '\', '_')];
        mkdirNC(savePath)
        for z = 1:size(croppedVolume,3)
            SaveUIntTiff(squeeze(croppedVolume(:,:,z)),[savePath...
                '\run_' num2str(iRun, '%04d')...  
                '_img_' num2str(z,'%05u') ...
                '_channel_' num2str(iVolume, '%04d')...
                '.tif'
                ]);
        end
    end
end

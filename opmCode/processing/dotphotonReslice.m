% Reslice, dotphoton single cam. For single camera data performs reslicing
% including option to decompress dotphoton data.
clear
close all

pathList = {'.\reslicing';
%     './beadRegistration';
    './dotphotonCompress'};
addToPath(pathList)
javaaddpath(['./reslicing/OPMReconstruction/dist/OPMReconstruction.jar']);

tempDirectory = 'R:\tempVolumes';

rawDirectory        = 'G:\Data\accelerator';

plate               = '\20210318_bakal02_erk';

imagePath               = '\main\21-03-18\11-20-14';
% beadImagePath           = '\01_beads_561\18-07-30\10-48-17';
backgroundImagePath     = '\background\21-03-18\10-11-03';
loadVolumeStyle = 'dotPhoton';
cameraName = 'acq_rfl';

% Fixed BG option
override_background = false;
fixed_background = [97, 97, 97, 97];

% Reslicing settings
resliceSettings.cst             = 4;%2; % this is the binning factor (csat = 4 and pixelSize = 0.25 gives a voxel size of 1 um3
resliceSettings.pixelSize       = 0.25; % um
resliceSettings.binnedPixelSize = resliceSettings.cst * resliceSettings.pixelSize; 
resliceSettings.opmAngle        = 35; % um
resliceSettings.theta           = resliceSettings.opmAngle*pi/180;
resliceSettings.acq_ds          = 0; %not sure with this is, left over from Vincent code
resliceSettings.nThreads        = 32; % number of threads to run java recontruction with, should be comparable to number of cores on machine
resliceSettings.offset          = 100; % ensures negative values after background subtraction are not set to 0

%% Get common files
imageFolder            = [rawDirectory plate imagePath]; % use the main image folder so background definitely stays matched up
p = readParams([imageFolder '\parameters.txt']);
filterList = readtable(['Z:\Projects\OPM\filters\filterwheel.csv']);

%% Measuring background

backgroundPath  = [rawDirectory plate backgroundImagePath];
for iChannel = 1:numel(p.las_channels)
    backgroundFolder = [backgroundPath '\run_0\field_0' ...
        makeChannelPath(p, iChannel, cameraName)];
    if override_background
        background{iChannel} = fixed_background(iChannel);
    else
        background{iChannel} = measureBackground(backgroundFolder, loadVolumeStyle, tempDirectory);
    end
end

%% Reslicing beads - to have a record
% beadPath  = [rawDirectory plate beadImagePath];
% 
% imageFolder = beadPath;

% Get imaging parameters and set up reslicing
imagingParameters = readParams([imageFolder '\parameters.txt']);
% didnt complete all 100 
% imagingParameters.n_run = 92;

runList     = [1:imagingParameters.n_run]; % makes a list of runs to be resliced
fieldList   = 3%[1:20]%numel(imagingParameters.x_pos)]; % makes a list of fields to be resliced (1 field per x position)
runStart = 1 %26;
fieldStart = 1 %62;

runList = [1];
for iField = fieldList(fieldStart:end)
    for iRun = runList(runStart:end)
        fieldPath = [imageFolder '\run_' num2str(iRun-1)...
            '\field_' num2str(iField-1)]; 
        for iChannel = 1:numel(imagingParameters.las_channels)
            %% load Volume
            channelSubfolder = makeChannelPath(imagingParameters, iChannel, cameraName);
            volumePath = [fieldPath channelSubfolder];
            [volume timeStamp] = chooseVolumeLoadMethod(volumePath,...
                loadVolumeStyle, tempDirectory);
            %% Remove first frame if dropped
            % First frame sometimes dropped so drop frame 1 all the time
%             timeStamp = loadTimeStamp(volumePath);
            if timeStamp.Number(1) == 1
                volume = volume(:,:,2:end);
            end
            
            %% Subtract background
            volume = single(volume) - background{iChannel};
            volume(1:7,1:292,:) = 0; % remove time stamp
            %% Binning
            volume = fastOPMbinning(volume,resliceSettings.cst);
            %% Do reslicing
            [volume] = doReslicing(volume, background{iChannel}, ...
                imagingParameters, resliceSettings);    
            %% Saving
            savePath = [rawDirectory '\temp' plate imagePath...
                '\cst' num2str(resliceSettings.cst)...
                '\run_' num2str(iRun,'%04u')...
                '\field_' num2str(iField,'%04u')...
                getChannelSaveFolder(imagingParameters, filterList, iChannel)];
            mkdirNC(savePath);
            saveTiffStack(savePath,uint16(volume),'img');           
        end
    end
end


            
          
        
%% Functions. To tidy
function [background] = measureBackground(backgroundFolder, loadVolumeStyle, tempDirectory)
    volume = chooseVolumeLoadMethod(backgroundFolder, loadVolumeStyle, tempDirectory);
    volume(1:7,1:292,:) = 0;
    background = mean(volume,3);
end

function [channelPath] = makeChannelPath(p, iChannel, cameraName)
    channelPath = ['\' num2str(p.wavelength(p.las_channels(iChannel) + 1))...
        '\' num2str(p.fw_pos(iChannel))...
        '\' cameraName];
end

function [volume timeStamp] = chooseVolumeLoadMethod(im_dir, loadVolumeStyle, tempDirectory)
    switch loadVolumeStyle
        case 'dotPhoton'
            volume = loadDotPhoton(im_dir, tempDirectory);
            timeStamp = loadTimeStamp(im_dir);
        case 'matlab2020'
            volume = loadMicroManagerVolume2020(im_dir);
            timeStampRaw     = volume(1,1:14,:);
            for ii = 1:size(timeStampRaw,3)
                timeStamp(ii,:) = readFrameTime(timeStampRaw(:,:,ii));
            end
    end
end

function [channelSaveFolder] = getChannelSaveFolder(imagingParameters, filterList, iChannel)
filterCentre = filterList.Centre(...
    filterList.FilterNumber_labView_ == imagingParameters.fw_pos(iChannel));

if isnan(filterCentre)
    filterCentre = 'scatter'
end

channelSaveFolder = [...
    '\exc' num2str(imagingParameters.wavelength(imagingParameters.las_channels(iChannel) + 1)) ...
    '_filter' num2str(filterCentre)];
end

function [timeStamp] = loadTimeStamp(volumePath)
    timestampList = dir([volumePath '/*.mat']);
    timeStamp = [];
    for iTS = 1:numel(timestampList)
        temp = load([timestampList(iTS).folder '\' timestampList(iTS).name]);
        timeStamp = [timeStamp
            temp.timeStamp];
    end
end


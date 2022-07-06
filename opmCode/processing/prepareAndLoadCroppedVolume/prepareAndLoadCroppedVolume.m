function [volume, cellOrNucleus] = prepareAndLoadCroppedVolume(Fullpath, Settings, iField, iRun, marker)


if Settings.singleCamera
    markerFolder{1} = ['\' Settings.markerChannel];
    cellFolder{1} = ['\' Settings.cellChannel];
else
    [markerFolder cellFolder] = getImageFolders(Settings.markerChannel,...
        Settings.cellChannel, 'exc');
end

% get number of runs
runNumberList = fileCounter(Fullpath.processedData, 'run_*');
% get number of fields
runPath = [Fullpath.processedData '\run_' num2str(runNumberList(1),'%04u')];
fieldNumberList = fileCounter(runPath, '\field_*');
exampleVolumePath = [runPath '\field_' num2str(fieldNumberList(1),'%04u') '\' markerFolder{1}];
[Settings.cropStart Settings.cropEnd Settings.cropHeight Settings.fractionAfterCropping] = ...
    setCropFactor(Settings, exampleVolumePath);

runPath = [Fullpath.processedData '\run_' num2str(iRun,'%04u')];
fieldPath = [runPath '\field_' num2str(iField,'%04u')]; 

if marker
    volume = loadAndCropVolume(fieldPath, markerFolder, ...
                        Settings, [Fullpath.savepath '\croppedVolume' '\marker'], iField, iRun);
    cellOrNucleus = 'nucleus';
else
    volume = loadAndCropVolume(fieldPath, cellFolder, ...
                    Settings, [Fullpath.savepath '\croppedVolume' '\cell'], iField, iRun);
    cellOrNucleus = 'cell';
end

end



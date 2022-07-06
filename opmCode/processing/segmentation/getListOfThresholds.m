function [wellTable] = getListOfThresholds(Fullpath, Settings, iField, iRun, nucleus)
% Check thresholds. Measures the thresholds for all fields and time points
% (otsu)

switch nucleus
    case 'nucleus'
        nucleus = 1;
    case 'cell'
        nucleus = 0;
    otherwise
        error('Is it a cell or nucleus')
end

%% Load volume
[volume, cellOrNucleus] = prepareAndLoadCroppedVolume(Fullpath, Settings,...
        iField, iRun, nucleus);
    
%% Get well stats
well            = getWellThresholds(volume);
wellTable       = getVolumeInfo(volume, well);
wellTable.field = iField;
wellTable.run   = iRun;

end

function [well] = getWellThresholds(volume)
    well.level_2_take_1 = getOtsuThreshold(volume, 2, 1);
    well.level_2_take_2 = getOtsuThreshold(volume, 2, 2);
    well.level_1        = getOtsuThreshold(volume, 1, 1);
    well                = struct2table(well);
    well.subROIac       = mean(volume(:)) + std(double(volume(:)));
end

function [wellTable] = getVolumeInfo(volume, wellTable)
    mask = zeros(size(volume));
    mask(volume > wellTable.level_1) = 1;

    Stats = regionprops3(bwconncomp(mask), volume, 'Volume', 'MeanIntensity', 'MaxIntensity');
    
    wellTable.max     = max(Stats.Volume);
    wellTable.mean    = mean(Stats.Volume);
    wellTable.ratio   = wellTable.max / wellTable.mean;
end
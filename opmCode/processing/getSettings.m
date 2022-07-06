function [Settings] = getSettings()

%% crop settings
Settings.manualCropPercent = 10;
% Settings.markerChannel = [642];
% Settings.cellChannel = [488];
Settings.opmAngleDegrees = 35;
Settings.cst = 4;
Settings.pixelSize = 0.25;
Settings.offset     = 100; 

%% Display settings
Settings.strehlBox = 10;
Settings.rows = 2;
Settings.columns = 4;

%% nucleus settings
Settings.minVolumeNucleus = 50;

end
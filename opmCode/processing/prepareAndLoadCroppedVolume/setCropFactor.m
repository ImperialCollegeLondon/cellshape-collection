function [cropStart cropEnd cropHeight fractionAfterCropping] = setCropFactor(Settings, exampleVolumePath)
% Calculates and outputs the crop factors necessary for OPM 

%% Info about a reference dataset
field = [exampleVolumePath '\*.tif'];
list  = dir([field]);
imageInfo = imfinfo([exampleVolumePath '\' list(1).name]);

%% Calculate how much the image will be effected by OPM angle on each side
cropFactorTheory = numel(list) / tan(Settings.opmAngleDegrees*pi/180);
cropFactorTheory = cropFactorTheory/imageInfo.Height*100;

%% Add a further user define crop
additionalCropScalar=Settings.manualCropPercent/100 + 1;%/cropFactorTheory;
% additionalCropScalar=Settings.manualCropPercent/cropFactorTheory;

%% Combine
fractionAfterCropping=1-2*cropFactorTheory*additionalCropScalar/100;

%% Calculate where to crop

cropStart = floor((0.5-fractionAfterCropping/2)*imageInfo.Height);
cropEnd = floor((0.5+fractionAfterCropping/2)*imageInfo.Height);

cropHeight = cropEnd-cropStart;

end


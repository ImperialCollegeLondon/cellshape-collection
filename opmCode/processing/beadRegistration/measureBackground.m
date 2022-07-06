function [mu]=measureBackground(im_dir)
% now outputs background as an array so that fixed pattern noise can be
% subtracted

%% Load volume
% files = dir([im_dir '\*.tif']);
volume = loadMicroManagerVolume2020(im_dir);
% remove letters at top

volume(1:7,1:292,:) = 0;

% mu = mean(volume(:));
mu = mean(volume,3);
% stdev = std(volume(:));

% OUTPUTS:
% mean ROI pixel value
% ROI pixel standard deviation value


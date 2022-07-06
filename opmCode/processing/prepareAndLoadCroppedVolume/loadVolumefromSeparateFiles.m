function [volume] = loadVolumefromSeparateFiles(imagePath, Settings)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Generate list of image files
list = dir([imagePath '\*.tif']);
%% Load every image as tiff stack
[volume] = int16(readTiffStack(list)) - Settings.offset;
end


function [volume] = loadVolumefromSeparateFiles(imagePath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clearvars -except imagePath f

%% Generate list of image files
list = dir([imagePath '\*.tif']);
%% Load every image as tiff stack
[volume] = readTiffStack(list);
end


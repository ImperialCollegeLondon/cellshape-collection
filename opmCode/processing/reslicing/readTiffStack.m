function [imageStack] = readTiffStack(list)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clearvars -except list

%% Generate an empty volume
Image.info = imfinfo([list(1).folder '\' list(1).name]);
imageStack = zeros(Image.info.Height, Image.info.Width, numel(list), 'uint16');

for ii = 1:numel(list)
%     temp = Tiff([list(ii).folder '\' list(ii).name]);
    imageStack(:,:,ii) = imread([list(ii).folder '\' list(ii).name]);
end
end


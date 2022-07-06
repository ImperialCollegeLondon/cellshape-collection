function [] = saveTiffStack(save_path,reslice,fileName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% temp=strfind(fileName, '.');
% fileName =fileName(1:(temp(end)-1));
% clear temp

for z = 1:size(reslice,3)
    SaveUIntTiff(squeeze(reslice(:,:,z)),[save_path '\' fileName '_img_' num2str(z,'%05u') '.tif']);
end
end
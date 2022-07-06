function [] = saveTiffStack(save_path,reslice)
%UNTITLED3 Summary of this function goes here
%   incrementString is the name of the image (e.g. img in a z stack,
%   channel in a channel stack)



%explictly convert to uit16
reslice = uint16(reslice);
parfor z = 1:size(reslice,3)
    SaveUIntTiff(squeeze(reslice(:,:,z)),[save_path '\img_' num2str(z,'%05u') '.tif']);
end
end
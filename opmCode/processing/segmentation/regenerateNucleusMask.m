function [nucleusMask] = regenerateNucleusMask(nucleusStats, Fullpath, iField, iRun)

maskPath = [Fullpath.savepath '\nucleus\field_' num2str(iField, '%04d')...
    '\run_' num2str(iRun, '%04d')];

list = dir([maskPath '\*.tif']);

imageInfo = imfinfo([maskPath '\' list(1).name]);

nucleusMask = zeros(imageInfo.Height, imageInfo.Width, numel(list));


for ii = 1:size(nucleusStats,1)
    nucleusMask(nucleusStats(ii,:).VoxelIdxList{:}) = 1;
end
end


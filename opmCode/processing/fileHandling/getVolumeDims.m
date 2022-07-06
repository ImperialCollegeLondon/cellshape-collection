function [volumeDims] = getVolumeDims(volumePath)
    list = dir([volumePath '\*.tif']);
    Image.info = imfinfo([list(1).folder '\' list(1).name]);
    volumeDims = [Image.info.Height, Image.info.Width, numel(list)];
end
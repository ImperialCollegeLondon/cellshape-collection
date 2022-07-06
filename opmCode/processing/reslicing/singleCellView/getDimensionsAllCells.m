function [volumeDims] = getDimensionsAllCells(listCells, folder)
parfor iCell = 1:numel(listCells)
    iRun = 1; % need to consider just one time point
    iChannel = 1; % also need to consider only one channel
    listImages = dir([folder '\' listCells{iCell}...
        '\run_' num2str(iRun, '%04d') '*' ...
        '_channel_' num2str(iChannel, '%04d') '.tif']);
    volumeDims(iCell,:) = getVolumeDimensions(listImages);
% imageStack = zeros(Image.info.Height, Image.info.Width, numel(list), 'uint16');
end
end

function [volumeDims] = getVolumeDimensions(listImages)
    Image.info = imfinfo([listImages(1).folder '\' listImages(1).name]);
    volumeDims = [Image.info.Height, Image.info.Width, numel(listImages)];
end
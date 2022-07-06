function [imageStack files] = loadMicroManagerVolume2020(imageFolderPath)
%loadMicroManagerVolume loads a micromanager volume, where there are more
%than one stacks these are concactenated

%% Switch off annoying warning related to matlab not recognising bioformats
% warningID = 'MATLAB:imagesci:tiffmexutils:libtiffWarning';
% warning('off',warningID)

files = dir([imageFolderPath '\*.tif']);


% imageStack = loadVolumeStack(imageFolderPath, files(1));
imageStack = loadVolumeList(files(1));


if numel(files) > 1
    for nFile = 2:numel(files)
%         tempStack = loadVolumeStack(imageFolderPath, files(nFile));
        tempStack = loadVolumeList(files(nFile));
        imageStack = cat(3,imageStack,tempStack);
    end
end

end




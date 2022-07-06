function [volume] = loadVolumeList(list)
    volume = tiffreadVolume([list.folder '\' list.name]);
end
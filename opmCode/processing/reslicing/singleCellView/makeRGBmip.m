function [rgbMIP] = makeRGBmip(volumeArray, grid)
% recieves an array of 3 volumes and makes and RGB (normalised) MIP
if numel(volumeArray) ~= 3
    error('Incorrect number of volumes')
end

for iChannel = 1:numel(volumeArray)
    volume = normalise8Bit(volumeArray{iChannel});
    mip{iChannel} = mipSegmented(volume, grid);
end

rgbMIP = cat(3, mip{1}, mip{2}, mip{3});

end

function [volume] = normalise8Bit(volume)
if max(volume(:)) ~= 0 % no need to normalise if it is 0
    volume = double(volume);
    volume = volume / max(volume(:)) * 2^8;
end

volume = uint8(volume);

end
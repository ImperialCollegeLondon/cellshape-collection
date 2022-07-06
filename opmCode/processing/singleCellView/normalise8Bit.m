function [volume] = normalise8Bit(volume, saturation)

if nargin < 2
    saturation = 1;
end

if max(volume(:)) ~= 0 % no need to normalise if it is 0
    volume = double(volume);
    volume = volume / max(volume(:)) * 2^8 * saturation;
end

volume = uint8(volume);

end
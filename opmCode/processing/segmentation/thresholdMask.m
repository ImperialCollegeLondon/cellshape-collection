function [mask] = thresholdMask(volume, thresh, minVolume)
    mask = zeros(size(volume));
    mask(volume > thresh) = 1;

    mask = bwareaopen(mask, ceil(minVolume));
end
function [image] = roiVolume(volume, Stats)
    image    = volume(Stats.SubarrayIdx{:});
end
function [croppedVolume] = cropVolume(volume, subArrayIdx)
    croppedVolume = volume(subArrayIdx{:});
%     croppedVolume = padToBoxSize(croppedVolume, boxSize);  % size is now
%     set as part of the subArrayIdx
end
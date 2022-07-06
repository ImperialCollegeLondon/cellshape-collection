function [boundingBox] = getCropBox(cellVolume, Stats, strehlBox)
    boundingBox = zeros(size(cellVolume));
    boundingBox(Stats.SubarrayIdx{:}) = 1;
    boundingBox = imdilate(boundingBox,strel('cube',strehlBox));
    boundingBox = regionprops3(bwconncomp(boundingBox), 'SubarrayIdx');
    boundingBox = boundingBox.SubarrayIdx;
end
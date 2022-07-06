function [cropBox] = makeCropBox(targetSize, startingSize)
% make cropBox
cropBox = padToBoxSize(ones(targetSize), startingSize);
cropBox = regionprops3(bwconncomp(cropBox), 'SubarrayIdx');
cropBox = cropBox.SubarrayIdx;
end
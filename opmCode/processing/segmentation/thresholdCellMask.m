function [cellMask] = thresholdCellMask(volume, thresh)
    cellMask = zeros(size(volume));
    cellMask(volume > thresh) = 1;
end
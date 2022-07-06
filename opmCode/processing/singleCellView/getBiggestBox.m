function [imageSize] = getBiggestBox(BigStatsTable)
% Get size of the biggest possible bounding box so no images are cropped
    boundingBox = max(BigStatsTable.BoundingBox);
    imageSize(1) = boundingBox(5);
    imageSize(2) = boundingBox(4);
    imageSize(3) = boundingBox(6);
end
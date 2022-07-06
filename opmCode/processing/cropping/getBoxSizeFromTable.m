function [boxSize] = getBoxSizeFromTable(clusterTable)
    boxSize(1) = max(clusterTable.xDim);
    boxSize(2) = max(clusterTable.yDim);
    boxSize(3) = max(clusterTable.zDim);
end
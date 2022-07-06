function [boxSize] = getBoxSize(Stats)
    boxSize = max(Stats.BoundingBox) + 1; % need to add one as box size is counting from 0 not 1
    boxSize = boxSize(4:6);
    boxSize([1 2]) = boxSize([2 1]);
end
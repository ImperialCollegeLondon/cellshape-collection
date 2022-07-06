function [volume] = padToBoxSize(volume, boxSize)
    for dimension = 1:3
        [volume] = padMaskToBoxSizeOneDimension(volume, boxSize, dimension);
    end    
end

function [mask] = padMaskToBoxSizeOneDimension(mask, boxSize, dimension)
    mask = padarray(mask, floor((boxSize - size(mask))/2));
    while (size(mask,dimension) < boxSize(dimension))
        padsize = zeros(3,1);
        padsize(dimension) = 1;
        mask = padarray(mask, padsize, 'post');
    end
    if size(mask, dimension) ~= boxSize(dimension)
        error('box size correction failed')
    end
end
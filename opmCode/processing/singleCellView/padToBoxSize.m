function [volume] = padToBoxSize(volume, boxSize)
    for dimension = 1:3
        [volume] = padMaskToBoxSizeOneDimension(volume, boxSize, dimension);
    end    
end

function [mask] = padMaskToBoxSizeOneDimension(mask, boxSize, dimension)
    maskDims = size(mask);
    if numel(maskDims) < 3
        maskDims = [maskDims , 1];
    end

    mask = padarray(mask, floor((boxSize - maskDims)/2));
    while (size(mask,dimension) < boxSize(dimension))
        padsize = zeros(3,1);
        padsize(dimension) = 1;
        mask = padarray(mask, padsize, 'post');
    end
    if size(mask, dimension) ~= boxSize(dimension)
        error('box size correction failed')
    end
end
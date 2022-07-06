function [mask, nucleusMask] = centreonNucleus(mask, nucleusMask)
    nucleusPosition = regionprops3(nucleusMask, 'Centroid').Centroid;
    nucleusPosition([1 2]) = nucleusPosition([2 1]);% regionprops inverts x and y        
    maskDims = size(nucleusMask)/2;
    offset = round(maskDims - nucleusPosition);

    for iDim = 1:size(offset,2)
        iOffset = offset(iDim);
        padsize = zeros(3,1);
        padsize(iDim) = abs(iOffset) * 2;
       if iOffset < 0
           nucleusMask = padarray(nucleusMask, padsize, 'post');
           mask = padarray(mask, padsize, 'post');
       else
           nucleusMask = padarray(nucleusMask, padsize, 'pre');
           mask = padarray(mask, padsize, 'pre');
       end
    end
end
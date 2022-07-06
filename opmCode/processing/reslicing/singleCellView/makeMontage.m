function [montage] = makeMontage(images, nImages)

if nargin < 2
    nImages = numel(images);
end

rows = floor(sqrt(nImages));
columns = ceil(nImages / rows);

increment = 1;
for iRow = 1:rows
    for iColumn = 1:columns
        % ad an empty image if there are non left
        if increment <= nImages
            tempImage = images{increment};
        else
            tempImage = zeros(size(images{end}),'uint16');
        end
        % build up the row
        if iColumn == 1
            rowMontage = tempImage;                
        else
            rowMontage = [rowMontage tempImage];            
        end
    increment = increment + 1;
    end
    if iRow == 1
        montage = rowMontage;
    else
        montage = [montage 
            rowMontage];
    end  
rowMontage = [];
end
end

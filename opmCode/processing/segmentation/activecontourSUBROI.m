function [acMask] = activecontourSUBROI(volume,BW, nIterations, type)
    minIntensity = mean(volume(:)) + 3 * std(double(volume(:)));
    
    
    Stats = regionprops3(BW, volume, 'Volume', 'SubArrayIdx', 'MaxIntensity');
    Stats = Stats(Stats.MaxIntensity > minIntensity, :);
    
    acMask = zeros(size(BW), 'logical');
    for iROI = 1:size(Stats,1)
        acMask(Stats(iROI,:).SubarrayIdx{:}) = acCropSubROI(...
            volume(Stats(iROI,:).SubarrayIdx{:})...
            , BW(Stats(iROI,:).SubarrayIdx{:}), nIterations, type);
    end
end


function [acMask] = acCropSubROI(volume, BW, nIterations, type)
    acMask = activecontour(volume, BW, nIterations, type);

%     figure()
%     mip{1} = mipSegmented(volume) / max(volume(:));
%     mip{2} = mipSegmented(BW) / max(BW(:)) /5;
%     mip{3} = mipSegmented(acMask) / max(acMask(:)) /5;
%     imshow(cat(3,mip{1},mip{2}, mip{3}),[]);  
end
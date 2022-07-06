function [] = displayMIPsOverlay(volume, nucleusMask, cellMask)
    mip{2} = mipSegmented(normalise8Bit(volume, 5)); % saturate
    mip{1} = mipSegmented(normalise8Bit(nucleusMask));
    mip{3} = mipSegmented(normalise8Bit(cellMask));
    
    rgbMIP = cat(3, mip{1}, mip{2}, mip{3});
    imshow(rgbMIP)
end
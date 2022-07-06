function [thresh] = getOtsuThreshold(imageSubRegion, nLevels, useLevel)

    [thresholdAll] = multithresh(imageSubRegion, nLevels);
    thresh = thresholdAll(useLevel);

end
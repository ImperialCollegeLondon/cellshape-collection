function [translation] = getTranslation(nucleusMask, boxSize)
%% Centre nucleus on mask
    subROIstatsNucleus = regionprops3(nucleusMask, 'Centroid');
    nucleusCentroid = round(subROIstatsNucleus.Centroid);
    % swap centroid to xyz coordinates
    nucleusCentroid([1 2]) = nucleusCentroid([2 1]);
    targetCentroid = boxSize/2;
    translation = targetCentroid - nucleusCentroid;
    translation([1 2]) = translation([2 1]); % need to swap back so correct translation applies. Stupid matlab.
end
function [volume] = cropInZ(volume, keepFraction)
% v  = volume;
% keepFraction = 0.3;

% get size of dimension
dimSize = size(volume,1);

% find centre
centre = floor(dimSize/2);

topToKeep = centre + floor(keepFraction * dimSize / 2);
bottomToKeep = centre - floor(keepFraction * dimSize / 2);

volume = volume(bottomToKeep:topToKeep,:,:);

% imshow(squeeze(max(v,[],3)),[])
end
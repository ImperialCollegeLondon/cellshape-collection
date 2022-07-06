function [volume] = fastOPMbinning(volume,binningFactor)
%fastOPMbinning bins a 3D volume in x and y

% loop is needed to ensure that bilinear interpolation considers all pixels

reduce_lvl = floor(binningFactor/2); % each bi linear binning reduces the image size by factor 2 so only want to do half as many as the binning factor requires

for n = 1:reduce_lvl
    volume = imresize(volume,1/2,'Method','bilinear');
end

end


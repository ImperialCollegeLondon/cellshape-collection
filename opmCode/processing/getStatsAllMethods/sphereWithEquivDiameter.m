function [sphere] = sphereWithEquivDiameter(volume, singleCell)


maskCentroid = regionprops3(volume, 'Centroid');
xCoord = maskCentroid.Centroid(1);
yCoord = maskCentroid.Centroid(2);
zCoord = maskCentroid.Centroid(3);

for ii = 1:ndims(volume)
    gridSize{ii} = 1:size(volume,ii);
end

[x y z] = meshgrid(gridSize{2}, gridSize{1}, gridSize{3});



sphere = sqrt((x-xCoord).^2 +...
    (y-yCoord).^2 +...
    (z-zCoord).^2)...
    <= singleCell.EquivDiameter / 2;
end
function[CellStats, NucleusStats] = getCombinedStats(CellStats, NucleusStats)
    [CellStats, NucleusStats] = addNucleusCoordinatesToBoth(CellStats, NucleusStats);
    [CellStats, NucleusStats] = getOrbits(CellStats, NucleusStats);
    [CellStats, NucleusStats] = getAngleDifferences(CellStats,...
        NucleusStats);
    [CellStats, NucleusStats] = cell2nucStat(CellStats, NucleusStats);
end

function [CellStats, NucleusStats] = addNucleusCoordinatesToBoth(CellStats, NucleusStats)
    [NucleusStats] = addCoordinates(NucleusStats);
    CellStats.xCoord = NucleusStats.xCoord;
    CellStats.yCoord = NucleusStats.yCoord;
    CellStats.zCoord = NucleusStats.zCoord;
end

function [Stats] = addCoordinates(Stats)
    Stats.xCoord = Stats.Centroid(:,1);
    Stats.yCoord = Stats.Centroid(:,2);
    Stats.zCoord = Stats.Centroid(:,3);
end

function [CellStats, NucleusStats] = cell2nucStat(CellStats, NucleusStats)
    CellStats.cell2nuc = CellStats.Volume ./ NucleusStats.Volume;
    NucleusStats.cell2nuc = CellStats.cell2nuc;
end

function[bigCellStats, bigNucleusStats] = getOrbits(bigCellStats, bigNucleusStats)
    bigCellStats.zOrbit = bigNucleusStats.Centroid(:,3) - bigCellStats.Centroid(:,3);
    bigNucleusStats.zOrbit = bigCellStats.zOrbit;
    bigCellStats.Orbit = vecnorm(bigCellStats.Centroid - bigNucleusStats.Centroid,2,2);
    bigNucleusStats.Orbit  = bigCellStats.Orbit ;
end

function [bigCellStats, bigNucleusStats] = getAngleDifferences( bigCellStats, bigNucleusStats)

[cellAngle] = convertAngleToCartesian(bigCellStats);
[nucleusAngle] = convertAngleToCartesian(bigNucleusStats);

dotProduct = dot(cellAngle,nucleusAngle,2);
magnitude = vecnorm(cellAngle,2,2) .* vecnorm(nucleusAngle,2,2);

angleBetween = acosd(dotProduct ./ magnitude);
angleBetween(find(imag(angleBetween) ~= 0)) = 0; % where the vecotrs are the same the doitproduct sometimes fails. For these ones set them to zero
angleBetween(angleBetween > 90 ) = 180 - angleBetween(angleBetween > 90 ); % don't care about direction the major axis points in
bigCellStats.AngleBetween = angleBetween;
bigNucleusStats.AngleBetween = bigCellStats.AngleBetween;
end

function [cellAngle] = convertAngleToCartesian(bigCellStats)
    [cellAngle(:,1), cellAngle(:,2), cellAngle(:,3)] = sph2cart(bigCellStats.Azimuth * pi/180, bigCellStats.Pitch * pi/180 ,1);
end
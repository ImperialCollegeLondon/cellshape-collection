function [Stats] = getExtraStats(Stats)
%getExtraStats Adds extra stats to Stats and outputs it

Stats.AxialExtent       = Stats.BoundingBox(:,6);           % cell height (from top to bottom of cell
Stats.MajorAxis         = max(Stats.PrincipalAxisLength')'; % major axis length
Stats.MinorAxis         = min(Stats.PrincipalAxisLength')'; % minor axis length
Stats.secondMajor       = median(Stats.PrincipalAxisLength,2);
Stats.Eccentricity      = sqrt(1-(Stats.MinorAxis./Stats.MajorAxis).^2);       % how streteched the ellipsoid is
Stats.secondEccentricity      = sqrt(1-(Stats.secondMajor./Stats.MajorAxis).^2);
Stats.Azimuth       = Stats.Orientation(:,1);           % angle in xy plane
Stats.Pitch       = Stats.Orientation(:,2);           % angle in xy plane (still checking)
Stats.Roll       = Stats.Orientation(:,3);           % angle around major axis
Stats.absPitch = Stats.Pitch;
Stats.Sphericity        =(pi^(1/3)*(6*Stats.Volume).^(2/3))./Stats.SurfaceArea; % sphericity of the mask
Stats.Vol2surf          = Stats.Volume./Stats.SurfaceArea;  % surface area to volume ratio
end
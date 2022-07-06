function [centroidList] = nucleusCentroids(runList, weightedCentroid)
%nucleusCentroids Recieves a list of .mat files containing cell and nucleus
%stats and generates a 1xnRuns cell contain [x y x] cooridinats of the
%centroid user can choose between using the centroid and the weighted
%centroid the boolean weighted centroid

for iRun = 1:numel(runList)
    centroidList{iRun} = getNucleusCentroid([runList(iRun).folder...
        '\' runList(iRun).name], weightedCentroid);
end

end

function [centroidList] = getNucleusCentroid(path, weightedCentroid)
%getNucleusCentroid Loads the .mat file on path and extracts the nucleus
%centroid from it. Caller can choose between using intensity weighted
%centroid or the masked centroid

% load the .mat file
load(path)

% get list of centroid positions.
if weightedCentroid
    centroidList = NucleusStats.WeightedCentroid;
else
    centroidList = NucleusStats.Centroid;
end


end
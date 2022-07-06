function [Stats] = removeShortTracks(Stats, fractionPresent)

nTimePoints = numel(Stats);
minOccurence = floor(nTimePoints * fractionPresent);



vertTable = vertcat(Stats{:});

tracks = unique(vertTable.timeTrack);

for iTimeTrack = 1:numel(tracks)
   temp = getSingleCellStat(vertTable, tracks(iTimeTrack), 'timeTrack');
   nOccurences(iTimeTrack) = size(temp,1);
end

tracksToDrop = tracks(find(nOccurences < minOccurence));

for iRun = 1:nTimePoints
    temp = Stats{iRun};
    temp(ismember(temp.timeTrack, tracksToDrop),:) = [];
    Stats{iRun} = temp;
end

end
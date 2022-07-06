function [Stats] = getRunTrackedStats(Stats)
    for iRun = 1:size(Stats,1)
        centroidList{iRun} = Stats{iRun}.Centroid;;
        Stats{iRun}.runNumber = repmat(iRun,...
            size(Stats{iRun}.Volume));
    end

    centroidList(find(cellfun(@isempty,centroidList))) = {[-Inf, - Inf, -Inf]};
    tracks = simpletracker(centroidList,'MaxLinkingDistance', 30, ...
        'MaxGapClosing', 3);

    for iRun = 1:size(Stats,1)
        if numel(Stats{iRun}) ~= 0
            Stats{iRun}.timeTrack = getTracks(Stats{iRun},...
                tracks, iRun);
        end
    end
end
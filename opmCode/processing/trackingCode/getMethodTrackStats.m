function [Stats] = getMethodTrackStats(Stats, methodList)
    for iMethod = 1:numel(methodList)
        centroidList{iMethod} = Stats{iMethod}.Centroid;
        Stats{iMethod}.methodNumber = repmat(iMethod,...
            size(Stats{iMethod}.Volume));
    end
    
    centroidList(find(cellfun(@isempty,centroidList))) = {[-Inf, - Inf, -Inf]};
    
    tracks = simpletracker(centroidList,'MaxLinkingDistance', 3, ...
        'MaxGapClosing', 5);

    for iMethod = 1:numel(methodList)
        if numel(Stats{iMethod}) ~= 0
            Stats{iMethod}.methodTrack = getTracks(Stats{iMethod},...
                tracks, iMethod);
        end
    end
end
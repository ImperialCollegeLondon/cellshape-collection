function [assignedTracks] = getTracks(NucleusStats, tracks, iRun)
    %addTracks recieves path to one set of stats. Adds the nucleus tracks to
    %it. Assigns nuclei to cells and saves the new, more complete, stats


    % generate an array assignedTracks to be added to the NucleusStats Table
    assignedTracks = zeros(size(NucleusStats,1),1);

    for iTrack = 1:numel(tracks) % looping through tracks
        oneTrack = tracks{iTrack}; % get one track, index iTrack 
        nucleusIndex = oneTrack(iRun); % get the index (in NucleusStats) of the nucleus corresponding to this track at this time point
        if ~isnan(nucleusIndex) % if Nan this track does not appear in this frame. only assign if track does appear
            assignedTracks(nucleusIndex) = iTrack; % assign iTrack to this nucleus (the correct one)
        end
    end
end
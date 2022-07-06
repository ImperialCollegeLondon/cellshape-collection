function [] = assignTracksAndSave(tracks, runList, savePath)
%assignTracksAndSave Loads the stats for each run. and adds a track index
%to each nucleus. Assigns the nuclei to the cells (removing nuclei from the
%analysis which are in cells touching the edge) then saves both

% load stats from one run
for iRun = 1:numel(runList)
    addTracks(runList(iRun).folder, runList(iRun).name,...
        tracks, savePath, iRun);
end

end

function [] = addTracks(path, fileName, tracks, savePath, iRun)
%addTracks recieves path to one set of stats. Adds the nucleus tracks to
%it. Assigns nuclei to cells and saves the new, more complete, stats

load([path '\' fileName]);

% generate an array assignedTracks to be added to the NucleusStats Table
assignedTracks = zeros(size(NucleusStats,1),1);

for iTrack = 1:numel(tracks) % looping through tracks
    oneTrack = tracks{iTrack}; % get one track, index iTrack 
    nucleusIndex = oneTrack(iRun); % get the index (in NucleusStats) of the nucleus corresponding to this track at this time point
    if ~isnan(nucleusIndex) % if Nan this track does not appear in this frame. only assign if track does appear
        assignedTracks(nucleusIndex) = iTrack; % assign iTrack to this nucleus (the correct one)
    end
end

% add to nucleus stats table
NucleusStats.index = assignedTracks;

% assign nucleus to cell, removing any nuclei which don't correspond to a
% cell
% [NucleusStats] = matchCellToNucleus(CellStats, NucleusStats);

% add track index to cell
CellStats.index = NucleusStats.index;

% save 
mkdirNC(savePath);
save([savePath '\' fileName], 'NucleusStats', 'CellStats');

end

function [NewNucleusStats] = matchCellToNucleus(CellStats, NucleusStats)
map=[];
NewNucleusStats = CellStats;
for i = 1:size(CellStats,1)
    for ii = 1:size(NucleusStats,1)
        test=ismember(CellStats.VoxelIdxList{i},NucleusStats.VoxelIdxList{ii});
        if max(test > 0)
            NewNucleusStats(i,:) = NucleusStats(ii,:);
            map = [map
                i ii];
        end
    end
end

end



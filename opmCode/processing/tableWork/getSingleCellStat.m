function [SingleLine, singleCellStat] = getSingleCellStat(Stats, iTrack, trackType, stat)
    SingleLine = Stats(getfield(Stats, trackType) == iTrack,:);
       
    if nargin > 3
        singleCellStat = getfield(SingleLine, stat);
    end
end
function [Stats] = findTextInTable(Stats, column, text)
    matchingIdx = ~cellfun(@isempty, strfind(getfield(Stats, column), text));
    Stats = Stats(matchingIdx,:);
end
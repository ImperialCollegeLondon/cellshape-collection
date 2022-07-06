function [vertTable] = reindexCells(Stats, columnName)

vertTable = vertcat(Stats{:});

oldIndex = getfield(vertTable, columnName);

indexList = unique(oldIndex);

newIndex = zeros(size(oldIndex));


increment = 1;
for index = indexList'
    newIndex(oldIndex == index) = increment
    increment = increment + 1 ;
end

vertTable = setfield(vertTable, columnName, newIndex);

end
function [Stats] = dealWithEmptyCells(Stats)

emptyCells = find(cellfun(@isempty,Stats));

firstNonEmptyCell = find(~cellfun(@isempty,Stats), 1, 'first');

columnNames = Stats{firstNonEmptyCell}.Properties.VariableNames;

for ii = 1:numel(emptyCells)
   Stats{emptyCells(ii)} =  cell2table(cell(0,numel(columnNames)),...
       'VariableNames', columnNames);
end
    

end
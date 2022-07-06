function [NewNucleusStats] = matchCellToNucleus(CellStats, NucleusStats)
map=[];
NewNucleusStats = table();
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
if numel(NewNucleusStats) == 0;  % empty table to still have columns
    NewNucleusStats = cell2table(cell(0,size(NucleusStats,2)), 'VariableNames', {NucleusStats.Properties.VariableNames{:}});
end

end
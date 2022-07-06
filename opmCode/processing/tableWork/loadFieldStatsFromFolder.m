function [Stats] = loadFieldStatsFromFolder(Folder, singleCell)
    load([Folder.folder '\' Folder.name '\field_'...
        num2str(singleCell.fieldNumber(1), '%04d') '.mat'])
    Stats = vertcat(Stats{:});
end
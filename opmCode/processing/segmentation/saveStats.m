function [] = saveStats(Stats, FullpathStats, cellOrNucleus, methodList, iMethod, iField)

savepath = [FullpathStats.savepath '\' cellOrNucleus '_' methodList{iMethod}];
mkdirNC(savepath)
save([savepath '\field_' num2str(iField, '%04d')])

toDrop = {
    'Centroid'
    'BoundingBox'
    'SubarrayIdx'
    'VoxelIdxList'
    'PrincipalAxisLength'
    'Orientation'
    'EigenVectors'
%     'methodNumber'
%     'methodTrack'
%     'branchImage'
    };

if sum((cellfun(@isempty,Stats))) ~= numel(Stats) % only save if there are cells in the well
%     t = cellfun(@size,Stats,'UniformOutput',false); % keep only the point with the most columns
%     t = vertcat(t{:});
%     [~, I] = max(t(:,2));
%     Stats = Stats(I);

    Stats = vertcat(Stats{:});
    Stats = removevars(Stats, toDrop);
    writetable(Stats,...
        [savepath '\field_' num2str(iField, '%04d') '.csv'])
end
    



end
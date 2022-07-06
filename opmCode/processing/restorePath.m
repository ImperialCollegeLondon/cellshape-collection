function [] = restorePath(pathsToAdd)
    for ii = 1:numel(pathsToAdd)
        rmpath(genpath(pathsToAdd{ii}));
    end
end
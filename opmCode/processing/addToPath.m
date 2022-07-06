function [] = addToPath(pathsToAdd)
    for ii = 1:numel(pathsToAdd)
        addpath(genpath(pathsToAdd{ii}));
    end
end
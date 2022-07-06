function [combinedVolume] = loadCombinedVolume(path,channels, Settings)
%loadCombinedVolume loads the volumes (named by channels) on the path and
% outputs the sum of volumes accross all channels

% load combined volume
for i = 1:numel(channels)
    if i == 1
        combinedVolume = loadVolumefromSeparateFiles([path '\' channels{i}], Settings);
    else
        combinedVolume = combinedVolume...
            + loadVolumefromSeparateFiles([path '\' channels{i}], Settings);
    end
end

% get crop factor


% crop the volume


end


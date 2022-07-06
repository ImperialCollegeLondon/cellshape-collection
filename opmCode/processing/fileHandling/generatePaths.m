function [Fullpath] = generatePaths(Path, savepath, analysed)
%generatePaths adds the full path to the raw data analysed should be left
%blank if analysing raw data

% where the raw data is found
Fullpath.rawData = strcat(Path.directory, Path.raw);

% path to the experiment (bead data and stuff will be here)
slashLocation = strfind(Fullpath.rawData, '\');
if (slashLocation(end) == strlength(Fullpath.rawData))
    error("Path.raw should not end with a \")
end
% experiment path ends 3 slashes from the end (\main\date\time)
Fullpath.experiment = Fullpath.rawData(1:(slashLocation(end-2)-1));

% analysed data path -  temp keyword is added at first slash of path.raw
slashLocation = strfind(Path.raw, '\');
if (slashLocation(1) == 1)
    error("Path.raw should not start with a \")
end
Fullpath.processed   = [Path.directory Path.raw(1:slashLocation(1)) 'temp\' ...
    Path.raw((slashLocation(1)+1):end)];

% add the path to the intermediate level analysed data (where data will be
% loaded from to be analysed. If this is empty assume the data to be
% analysed is raw data so no need to pass back 

if exist('analysed')
    Fullpath.processedData = [Fullpath.processed analysed];
else % don't pass back Fullpath.data
    analysed = []; % created as a placeholder for when generating savePath
end

Fullpath.savepath = [Fullpath.processed analysed savepath];

end


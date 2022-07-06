function [fileNumber names] = fileCounter(path, fileName)
%fileCounter counts the number of files with fileName in path. Outputs
%[1:1:totalNumber] allowing the user to step through files. This is more
%robust to ordering than using dir (which is sensitive to 0 padding)

list = dir([path '\' fileName]);
if isempty(list)
    error('No files found, check path and filename are correct')
end

fileNumber = [1:numel(list)];

names = {list.name};

end


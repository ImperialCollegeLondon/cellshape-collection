function [folder] = upOneFolderLevel(folder, nLevels)
%upOneFolderLevel moves up one folder level in the text string folder
if nargin < 2
    nLevels = 1;
end

breakPoint  = strfind(folder, '\');
breakPoint = breakPoint(end - nLevels + 1) - 1;

folder = folder(1:breakPoint);

end


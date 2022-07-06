function [SN] = getCameraSerialNumber(serialNumberTable, folder)
cameraName = getTopFolder(folder);
cameraRow = serialNumberTable(strcmp(serialNumberTable.folderName, cameraName),:);
SN = cameraRow.serialNumber{1};
end



% 
% function [SN] = getSerialNumberFromTable(serialNumberTable, cameraName)
% 
% 
% end
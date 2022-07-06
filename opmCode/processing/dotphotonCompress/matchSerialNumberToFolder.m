function[serialNumber] = matchSerialNumberToFolder(SN)
    for ii = 1:size(SN,1)
        serialNumber(ii).folderName = SN{ii,1};
        serialNumber(ii).serialNumber = SN{ii,2};
    end
    serialNumber = struct2table(serialNumber);
end
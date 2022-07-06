function [markerFolder cellFolder] = getImageFolders(markerChannel, cellChannel, channelName)
%getImageFolders generates two cell arrays containg (as characters) the
%names of the excitation and detection channels

for i = 1:numel(cellChannel)
    cellFolder{i} = [channelName num2str(cellChannel(i))];
end

for i = 1:numel(markerChannel)
    markerFolder{i} = [channelName num2str(markerChannel(i))];
end

end


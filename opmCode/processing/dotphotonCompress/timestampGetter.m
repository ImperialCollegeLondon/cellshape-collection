function [] = timestampGetter(folder)
%% Reads out the machine time stamps and saves a .mat file with all of them in this folder.
%% Does not transfer the time stamp into human readable format save grey values only

warningID = 'MATLAB:imagesci:tiffmexutils:libtiffWarning';
warning('off',warningID)

imageList = dir([folder '\*.tif']);

for iImage = 1:numel(imageList);
    filename = [folder '\' imageList(iImage).name];
    getAndSave(filename);
end
%% Turn warning back on (just in case)
warning('on',warningID)

end


function [] = getAndSave(filename)
    [timeStampRaw, frame] = getFileTimeStamp(filename);
    newFileName = removeFileExtension(filename);
    save(newFileName, 'timeStampRaw', 'frame')
end



function [timeStampRaw, frame] = getFileTimeStamp(filename)
    InfoImage=imfinfo(filename);
    NumberImages=length(InfoImage);
    FileID = tifflib('open',char(filename),'r');
    for iFrame = 1:NumberImages
        timeStampRaw{iFrame} = getRawTimeStamp(FileID, iFrame);
        frame(iFrame,:) = readFrameTime(timeStampRaw{iFrame});
    end
end

function [timeStampRaw] = getRawTimeStamp(FileID, iFrame)
    tifflib('setDirectory',FileID,iFrame-1);
    imageStrip = tifflib('readEncodedStrip',FileID,0);
    timeStampRaw = imageStrip(1,1:16);
end


function [name] = removeFileExtension(name)
%removeFileExtension removes the file extension (everything after the '.')

breakPoint  = strfind(name, '.');
if ~isempty(breakPoint) % if no breakpoint is found then do nothing
    name        = name(1:(breakPoint-1));
end

end
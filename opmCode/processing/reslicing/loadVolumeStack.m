function [imageStack] = loadVolumeStack(imageFolderPath, files)
%loadVolumeStack loads the volume as a tiff stack. 

FileTif = [imageFolderPath '\' files.name];
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages= length(InfoImage);
imageStack=zeros(nImage,mImage,NumberImages,'uint16');

FileID = tifflib('open',char(FileTif),'r');
rps = tifflib('getField',FileID,Tiff.TagID.RowsPerStrip);
% FileID=Tiff(FileTif);
% rps  = FileID.TagID.RowsPerStrip;

for i=1:NumberImages
    tifflib('setDirectory',FileID,i-1);
    % Go through each strip of data.
    rps = min(rps,nImage);
    for r = 1:rps:nImage
        row_inds = r:min(nImage,r+rps-1);
        stripNum = tifflib('computeStrip',FileID,r);
        imageStack(row_inds,:,i) = tifflib('readEncodedStrip',FileID,stripNum-1);
    end
end
tifflib('close',FileID);

end


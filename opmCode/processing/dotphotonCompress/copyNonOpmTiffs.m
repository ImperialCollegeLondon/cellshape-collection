function [] = copyNonOpmTiffs(folderRaw, folderCompressed)
% copy all non tiff files that could be associated with the images
    command =['robocopy "' folderRaw '" "' folderCompressed '" /s /MT /Move'];
    status = system(command);
end
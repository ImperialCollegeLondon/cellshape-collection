function [] = copyNonTiffs(folderRaw, folderCompressed)
% copy all non tiff files that could be associated with the images
    command =['robocopy "' folderRaw '" "' folderCompressed '" /s /MT /Move /XF "acq_rfl_MMStack*.ome.tif" "MMStack*.ome.tif"'];
    status = system(command);
end
function [combinedVolume] = loadAndCropVolume(imagePath, channels, Settings, savepath, field, run)
%loadAndCropVolume Loads and crops volume. Combines images which are of the
%same component (e.g. actin and tubulin in seperate channels in cell
%images). Cropping is to remove the OPM diagonal angle

% Load images (combine multple channels into single colour)
[combinedVolume] = loadCombinedVolume(imagePath, channels, Settings);

% Crop the volume
combinedVolume = combinedVolume((Settings.cropStart+1):Settings.cropEnd,:,:);
% if Settings.saveIntermediateMask
% savePath = [savepath '\field_' num2str(field,'%03u')];
% mkdirNC(savePath)
% saveTiffStack(savePath,combinedVolume, ['run_' num2str(run,'%03u')]);
% end

end
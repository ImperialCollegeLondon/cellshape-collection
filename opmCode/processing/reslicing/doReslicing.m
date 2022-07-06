function [volume] = doReslicing(volume, background, ...
    imagingParameters, resliceSettings)


[volume imagingParameters.backgroundCorrection] = ...
    convertToInt16(volume, background);
[volume, imagingParameters.nx, imagingParameters.ny] = volumeToList(volume);

volume = resliceJava(volume, resliceSettings,imagingParameters);



volume = convertToUInt16(volume, imagingParameters.backgroundCorrection, resliceSettings);

end



function [list, nx, ny] = volumeToList(volume)
%volumeToList returns the list as a 1D array and the x and y dimensions of
%the image for java reslicing

%% Switch off annoying warning related to matlab not recognising bioformats
% get dimensions of the raw volume
[ny nx nz] = size(volume); % ny and nx swapped as matlab defines width differently
% convert volume to list (for Java)
list = java.util.ArrayList;
volume = int16(volume); % should already be but needed for java. Does not take much time
for i = 1:nz
    tmp = squeeze(volume(:,:,i));
    tmp = reshape(tmp',1,nx * ny );
    list.add(tmp);
end

end

function [volume backgroundCorrection] = convertToInt16(volume, background)
% necessary as java reslicing oly takes a short (int16). This means I am
% still able to use the full dynamic range of the camera
backgroundCorrection = 2^15 - max(background(:));
volume = int16(volume - backgroundCorrection); % covert to short for java. 
if max(volume(:)) > 2^15 | min(volume(:)) < -2^15
    error('over flow error')
end
end

function [volume] = convertToUInt16(volume, backgroundCorrection, resliceSettings)
volume = single(volume) + backgroundCorrection + resliceSettings.offset;
if max(volume(:)) > 2^16 | min(volume(:)) < 0
    error('over flow error')
end

volume = uint16(volume);
end

function [Jout] = resliceJava(volumeList,Settings,imagingParameters)
%resliceJava reslices OPM data using the java code written by Ian Munro
%available on github here https://github.com/ImperialCollegeLondon/OPM-Java-reconstruction/blob/master/OPM/OPMReconstruction.java

% generate a struct of relevant variables to pass
p.theta         = Settings.theta;;
p.trg_dist      = imagingParameters.trg_dist;;
p.pix_size      = Settings.binnedPixelSize;
p.acq_ds        = Settings.acq_ds; % to confirm with Vincent Maioli what this is
p.nThreads      = Settings.nThreads; 

% initialise reconstructor - only needed once - will look at ways to remove
% if already on path
recon = OPM.OPMReconstruction(p.nThreads, p.theta, p.pix_size, p.trg_dist, p.acq_ds );

Jout = recon.reconstruct(volumeList,imagingParameters.nx,...
    imagingParameters.ny, - imagingParameters.backgroundCorrection);

nzout = recon.getSizeZ;
nyout = recon.getSizeY;

if ~isempty(Jout)
    Jout = reshape(Jout,[imagingParameters.nx nyout nzout]);
    Jout = permute(Jout,[2,1,3]);
%     runtime = toc
%     imagesc(squeeze(Jout(:,:,floor(nzout/2))));
else 
    Jout2 = recon.getOversize();
    nz = size(Jout2,1);
    Jout = zeros([nyout, imagingParameters.nx, nz]);
    for ii = 1:nz
        Jout(:,:,ii) = reshape(squeeze(Jout2(ii,:)),[imagingParameters.nx nyout])'; % ' so ends up the same aspect ratio as if it was not oversized
    end
%     Jout = reshape(Jout,[imagingParameters.nx nyout nzout ]);
%     imagesc(squeeze(Jout(floor(nzout/2),:,:))');
%     runtime = toc
end

end
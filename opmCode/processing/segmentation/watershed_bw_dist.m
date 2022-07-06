function [binaryWatershedImage split] = watershed_bw_dist(binaryImage, Settings, savepath, field, run)
%% Watersheds a volume seperating two connected nuclei using the distance to the edge

% otsuIntensityImage = MarkerSegmented.otsuIntensityImage;
% clearvars -except otsuIntensityImage imagePath Settings field run

%% Transform each pixel into a distance from nearest 0
pad = 1;
binaryImage = padarray(binaryImage, [pad, pad, pad]);
distImage = bwdist(~binaryImage);
% maxDistImage = max(distImage(:));
%% Smooth out outliers
distImage = smooth3(distImage,'box', [9 9 9]);
% distImage = distImage * maxDistImage / max(distImage(:));
%% Remove any increase in size from the smoothing
distImage(~binaryImage) = 0;
distImage = distImage(pad+1:end-pad,pad+1:end-pad,pad+1:end-pad);
temp = distImage; % used for debugging)

%% watershed

distImage(distImage==0) = inf; % Raise waterlevel of background
watershedImage=watershed( - distImage); %% Water rised from the background to troughs inside the nuclei

%% Binarise watershed image


if max(watershedImage(:)) <= 2 % only one nucleus found
    split = 0; % no nuclei are split
else
    split = max(watershedImage(:)) - 2; % number of splitting events
end   
binaryWatershedImage = false(size(watershedImage)); 
    binaryWatershedImage(watershedImage>1) = 1; % set background to 


%% Fill holes in binarised mask
binaryWatershedImage = padarray(binaryWatershedImage, [pad, pad, pad]);
[binaryWatershedImage]=fill_holes3D(binaryWatershedImage);
binaryWatershedImage = binaryWatershedImage(pad+1:end-pad,pad+1:end-pad,pad+1:end-pad);

% %% Save if necessary
% if Settings.saveIntermediateMask
%     savePath = [savepath '\watershed' '\field_' num2str(field,'%03u')];
%     mkdirNC(savePath)
%     saveTiffStackUint8(savePath,binaryWatershedImage, ['run_' num2str(run,'%03u')]);
% end


end
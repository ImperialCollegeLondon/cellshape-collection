function [tForm] = getBeadTransform(beadPath, movingChannel, referenceChannel,...
    leftRightFlip, bgMoving, bgReference, scaleMoving, scaleReference, old)

if nargin < 9
    old = false; % it is using the new micomanager code
end

zoomx = [400:800];
zoomy = zoomx;

if old 
    volumeMoving    = double(loadMicroManagerVolume2020([beadPath movingChannel '\run_0\field_0'])) - bgMoving;
    volumeReference = double(loadMicroManagerVolume2020([beadPath referenceChannel '\run_0\field_0'])) - bgReference;
else
    volumeMoving    = double(loadMicroManagerVolume2020([beadPath movingChannel])) - bgMoving;
    volumeReference = double(loadMicroManagerVolume2020([beadPath referenceChannel])) - bgReference;
end

volumeMoving(1:7,:,:)       = []; % remove time stamp (must be removed so doesn't skew registration)
volumeReference(1:7,:,:)    = [];

if leftRightFlip
    volumeMoving = fliplr(volumeMoving);
end

%% Get transform

[optimizer, metric] = imregconfig('multimodal');
optimizer.MaximumIterations = 300;
increment = 1;

for ii = 1:5:20%100:size(volumeReference,3)
	tForm = imregtform(volumeMoving(:,:,ii), volumeReference(:,:,ii),...
                    'rigid',optimizer,metric);%, 'Displayoptimization', true);
    tFormMatrix(:,:,increment) = tForm.T;
    increment = increment + 1;
end
                
tForm.T = mean(tFormMatrix,3);
%% Test
if leftRightFlip % flip back so doing the same transform again
    volumeMoving = fliplr(volumeMoving);
end

[volumeMovingTransformed] = affineTransformVolume(...
    volumeMoving, tForm, leftRightFlip);

%% Display
rMoving = scaleMoving - mean(bgMoving(:));
rReference = scaleReference - mean(bgReference(:));

image = randi(size(volumeMoving,3));
figure()
subplot(1,2,1)
imrgbpair(volumeMoving(zoomx, zoomy,image),volumeReference(zoomx, zoomy,image), rReference, rMoving);
title('Raw')

subplot(1,2,2)
imrgbpair(volumeMovingTransformed(zoomx, zoomy,image),volumeReference(zoomx, zoomy,image), rReference, rMoving);
title('Transformed')
end
function [tForm] = getBeadTransformManual(beadPath, movingChannel, referenceChannel,...
    leftRightFlip, bgMoving, bgReference, scaleMoving, scaleReference)

zoomx = [400:800];
zoomy = zoomx;

volumeMoving    = double(loadMicroManagerVolume2020([beadPath movingChannel])) - bgMoving;
volumeReference = double(loadMicroManagerVolume2020([beadPath referenceChannel])) - bgReference;

volumeMoving(1:7,:,:)       = []; % remove time stamp (must be removed so doesn't skew registration)
volumeReference(1:7,:,:)    = [];

% try transform
if leftRightFlip
    volumeMoving = fliplr(volumeMoving);
end
[optimizer, metric] = imregconfig('multimodal');
tForm = imregtform(volumeMoving(:,:,1), volumeReference(:,:,1),...
                    'rigid',optimizer,metric);
                
if leftRightFlip % flip back so doing the same transform again
    volumeMoving = fliplr(volumeMoving);
end

%%

% user enters transform to try
 angle = 1;%%degrees
 xshift = -8;
 yshift = 4;
 xscale = 1;
 yscale = 1;

 
% make transform
tForm.T(3,1) = xshift;
tForm.T(3,2) = yshift;
angle = angle * pi / 180;
tForm.T(1,1) = xscale * cos(angle);
tForm.T(2,2) = yscale * cos(angle);
tForm.T(1,2) = -sin(angle);
tForm.T(2,1) = -tForm.T(1,2);
% Test


[volumeMovingTransformed] = affineTransformVolume(...
    volumeMoving, tForm, leftRightFlip);

% Display
rMoving = scaleMoving - mean(bgMoving(:));
rReference = scaleReference - mean(bgReference(:));

image = 1%randi(size(volumeMoving,3));

% figure()
subplot(1,2,1)
imrgbpair(volumeMoving(zoomx, zoomy,image),volumeReference(zoomx, zoomy,image), rReference, rMoving);
title('Raw')

subplot(1,2,2)
imrgbpair(volumeMovingTransformed(zoomx, zoomy,image),volumeReference(zoomx, zoomy,image), rReference, rMoving);
title('Transformed')

end
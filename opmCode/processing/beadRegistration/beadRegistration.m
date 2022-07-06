function [tForm, Moving, Reference] = beadRegistration(rawDirectory,...
    plate, beadImagePath, backgroundImagePath, Moving, Reference,...
    leftRightFlip, automaticTransform, loadVolumeStyle)

movingChannel = [Moving.name '\run_0\field_0'];
referenceChannel = [Reference.name '\run_0\field_0'] ;

wavelengthMoving = Moving.wavelength ;
wavelengthReference = Reference.wavelength;
switch loadVolumeStyle
    case 'oldMicroManager'
        beadPath        = [rawDirectory plate beadImagePath];
        backgroundPath  = [rawDirectory plate backgroundImagePath];        
    otherwise
        beadPath        = [rawDirectory plate beadImagePath];
        backgroundPath  = [rawDirectory plate backgroundImagePath];
end

Moving.background    = measureBackground([backgroundPath movingChannel]);
Reference.background = measureBackground([backgroundPath referenceChannel]);;

scaleMoving     = 200;
scaleReference  = 200;


if automaticTransform
    tForm = getBeadTransform(beadPath, movingChannel, referenceChannel,...
        leftRightFlip, Moving.background, Reference.background, scaleMoving, scaleReference);
else
    [tForm] = getBeadTransformManual(beadPath, movingChannel, referenceChannel,...
        leftRightFlip, Moving.background, Reference.background, scaleMoving, scaleReference);
end

save([rawDirectory plate '\registrationNew_' num2str(wavelengthMoving)...
    '_' num2str(wavelengthReference)], 'tForm', 'Moving', 'Reference');
end
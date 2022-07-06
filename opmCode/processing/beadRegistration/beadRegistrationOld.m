function [tForm, Moving, Reference] = beadRegistrationOld(rawDirectory,...
    plate, beadImagePath, backgroundImagePath, Moving, Reference, leftRightFlip, automaticTransform)

movingChannel = Moving.name;
referenceChannel = Reference.name ;

wavelengthMoving = Moving.wavelength ;
wavelengthReference = Reference.wavelength;

beadPath        = [rawDirectory plate beadImagePath];
backgroundPath  = [rawDirectory plate backgroundImagePath];

Moving.background    = measureBackground([backgroundPath movingChannel '\run_0\field_0']);
Reference.background = measureBackground([backgroundPath referenceChannel '\run_0\field_0']);

scaleMoving     = 200;
scaleReference  = 200;


if automaticTransform
    tForm = getBeadTransform(beadPath, movingChannel, referenceChannel,...
        leftRightFlip, Moving.background, Reference.background, scaleMoving, scaleReference, true);
else
    [tForm] = getBeadTransformManual(beadPath, movingChannel, referenceChannel,...
        leftRightFlip, Moving.background, Reference.background, scaleMoving, scaleReference);
end

save([rawDirectory plate '\registrationNew_' num2str(wavelengthMoving)...
    '_' num2str(wavelengthReference)], 'tForm', 'Moving', 'Reference');
end
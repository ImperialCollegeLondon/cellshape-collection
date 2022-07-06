function [volume, background] = subtractBackgroundAndTransform(volume, tForm,...
    leftRightFlip, Moving, Reference, folder)
    
    cameraName = getTopFolder(folder);
    if strcmp(['\' cameraName], Moving.name)
        [volume, background] = subtractBackground(volume, Moving);
        volume = affineTransformVolume(volume, tForm, leftRightFlip);
        disp('transformed')
    else
        [volume, background] = subtractBackground(volume, Reference);
        disp('not transformed')
    end

end

function [volume, background] = subtractBackground(volume, Camera)
    volume = single(volume) - Camera.background;
    volume(1:7,1:292,:) = 0; % remove time stamp
    background = Camera.background;
end
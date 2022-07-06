function [volume] = centreOnNucleus(volume)
    translation = getNucleusTranslation(volume{end}); % last volume is nucleus mask
    for iChannel = 1:4
        volume{iChannel} =...
            imtranslate(volume{iChannel}, translation);
    end
end

function [translation] = getNucleusTranslation(volume)
    volume(volume < 256) = 0; % remove any parts of mask which are not the "true" mask
    if sum(volume(:)) > 0
        translation = getTranslation(bwconncomp(volume), size(volume));
    else
        translation = [NaN, NaN, NaN];
    end
end
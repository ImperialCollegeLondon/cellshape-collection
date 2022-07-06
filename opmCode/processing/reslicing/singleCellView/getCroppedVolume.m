function [croppedVolume] = getCroppedVolume(cellVolume, nucleusVolume,...
        CellStats, NucleusStats, boxSize)
    croppedVolume{1}   = cropVolumeFromTable(cellVolume,...
        nucleusVolume, CellStats, NucleusStats, boxSize, 0);
    croppedVolume{2}   = cropVolumeFromTable(cellVolume,...
        nucleusVolume, CellStats, NucleusStats, boxSize, 1);

    [croppedVolume{3}, croppedVolume{4}] = makeCroppedMaskFromTable(...
        cellVolume, CellStats, NucleusStats, boxSize);

    for ii = 1:numel(croppedVolume)
        croppedVolume{ii} = padToBoxSize(croppedVolume{ii}, boxSize);
    end
    % centre on nucleus mask
    translation = getTranslation(croppedVolume{4}, boxSize);
    for ii = 1:numel(croppedVolume)
        croppedVolume{ii} = imtranslate(croppedVolume{ii}, translation);
    end
end

function [croppedVolume] = cropVolumeFromTable(cellVolume, nucleusVolume,...
    CellStats, NucleusStats, boxSize, nucleus)

    if nucleus
        Stats = NucleusStats;
        volume = nucleusVolume;
    else
        Stats = CellStats;
        volume = cellVolume;
    end
    croppedVolume = zeros(size(volume), 'uint16');
    croppedVolume(Stats.VoxelIdxList{:}) = volume(Stats.VoxelIdxList{:});
%     croppedVolume = padarray(croppedVolume, boxSize);
%     % crop out centred on nucleus CoM
%     centroidVolume = zeros(size(volume));
%     centroidVolume(floor(NucleusStats.Centroid)) = 1;
%     
%     centroidVolume = imdilate(centroidVolume, strel('cuboid',boxSize));
%     centroidVolume = padarray(centroidVolume, boxSize);
    croppedVolume = croppedVolume(CellStats.SubarrayIdx{:}); % always use cell stats so image can be overlaid
end

function [croppedCellMask, croppedNucleusMask] = makeCroppedMaskFromTable(...
    volume, CellStats, NucleusStats, boxSize)

    cellMask = zeros(size(volume), 'uint16');
    cellMask(CellStats.VoxelIdxList{:}) = 1;
    nucleusMask = zeros(size(volume), 'uint16');
    nucleusMask(NucleusStats.VoxelIdxList{:}) = 1;
    
    croppedCellMask     = cropVolumeFromTable(cellMask, nucleusMask,...
        CellStats, NucleusStats, boxSize, 0);
    croppedNucleusMask  = cropVolumeFromTable(cellMask, nucleusMask,...
        CellStats, NucleusStats, boxSize, 1);
end

%% Pad to box size
function [volume] = padToBoxSize(volume, boxSize)
    for dimension = 1:3
        [volume] = padMaskToBoxSizeOneDimension(volume, boxSize, dimension);
    end    
end

function [mask] = padMaskToBoxSizeOneDimension(mask, boxSize, dimension)
    mask = padarray(mask, floor((boxSize - size(mask))/2));
    while (size(mask,dimension) < boxSize(dimension))
        padsize = zeros(3,1);
        padsize(dimension) = 1;
        mask = padarray(mask, padsize, 'post');
    end
    if size(mask, dimension) ~= boxSize(dimension)
        error('box size correction failed')
    end
end



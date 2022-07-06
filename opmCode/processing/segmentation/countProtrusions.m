function [runStats, volume] = countProtrusions(runStats, nucleusStats, minBranchLength, volumeDims)
    for iCell = 1:size(runStats, 1)
       singleCell = runStats(iCell,:);
       singleNucleus = nucleusStats(iCell,:);
       mask = makeCroppedMask(volumeDims, singleCell);
       skeleton = bwskel(mask,'MinBranchLength',minBranchLength);
       endPoints = bwmorph3(skeleton,'endpoints');
       sphere = sphereWithEquivDiameter(...
           makeCroppedMask(volumeDims, singleNucleus, singleCell),... % use nucleus mask to define the CoM
           singleCell);
       protrusions = endPoints & ~sphere;
       nProtrusions(iCell) = sum(protrusions(:));
       
       %% For debugging
       volume{1} = mask;
        volume{2} = protrusions;
        volume{3} = skeleton;
        
        for iVolume = 1:numel(volume)
            v{iVolume} = double(mipSegmented(volume{iVolume}));
        end
        image{iCell} = cat(3,v{1},v{2}, v{3});
        %         imshow(image{iCell});
        
        %% Output for Matt debugging
        volume{1} = mask;
        volume{2} = protrusions;
        volume{3} = sphere;
        volume{4} = skeleton;
        
        sn = singleCell.serialNumber{1};
        
%         savePath = [protrusionSavePath '\' strrep(sn, '\', '_')];
%         mkdirNC(savePath);
%         
%         for iVolume = 1:numel(volume)
%             croppedVolume = uint16(volume{iVolume});
%             for z = 1:size(croppedVolume,3)
%                 SaveUIntTiff(squeeze(croppedVolume(:,:,z)),[savePath...
%                     '\run_' num2str(singleCell.runNumber, '%04d')...  
%                     '_img_' num2str(z,'%05u') ...
%                     '_channel_' num2str(iVolume, '%04d')...
%                     '.tif'
%                     ]);
%             end
%         end
        
        

    end
   if size(runStats, 1) > 0
       runStats.nProtrusions = nProtrusions';
       runStats.branchImage = image';
   else
       runStats.nProtrusions = zeros(0);
       runStats.branchImage = zeros(0);
   end
   
end

function [mask] = makeCroppedMask(volumeDims, singleElement, singleCell)
    if nargin < 3
        singleCell = singleElement; % single cell is the table for the cell (largest element) so should define the bounding box when making a nucleus mask
    end
    mask = zeros(volumeDims, 'logical');
    mask(singleElement.VoxelIdxList{:}) = 1;
    mask = padarray(mask(singleCell.SubarrayIdx{:}), [10 10 10]);
end
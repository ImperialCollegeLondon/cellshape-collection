function [maskSum] = cumulativeMask(yz)

for iCell = 1:numel(yz)
   if iCell == 1
       maskSum = yz{iCell};
   else
       maskSum = maskSum + yz{iCell};
   end
end

% if max(maskSum(:)) < numel(yz)
%     maskSum(maskSum > 0) = maskSum(maskSum > 0) + (numel(yz) - max(maskSum(:))); % make it so that the brightest voxel is the same value in all images
% end

end
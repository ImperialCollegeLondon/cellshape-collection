function [Stats] = addBoxDimensions(Stats)
for iStats = 1:numel(Stats)
   tempStats = Stats{iStats};
   if ~isempty(tempStats)
       boundingBox = tempStats.BoundingBox;
       tempStats.yDim = boundingBox(:,4);
       tempStats.xDim = boundingBox(:,5);
       tempStats.zDim = boundingBox(:,6);
       Stats{iStats} = tempStats;
   end
end
end
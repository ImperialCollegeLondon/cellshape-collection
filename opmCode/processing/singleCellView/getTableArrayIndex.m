function [subArrayIdx] = getTableArrayIndex(Stats)


s = cat(1, Stats.BoundingBox); %concatenate struct into matrix
%s has structure [left bottom width height]
t = [s(:,1) s(:,2) s(:,3) s(:,1)+s(:,4) s(:,2)+s(:,5) s(:,3)+s(:,6)]; 
%t has structure [left bottom right top]
leftBottomCorner = floor(min(t(:,1:3),[],1));
rightTopCorner = floor(max(t(:,4:6),[],1));
%boundingbox, again in [left bottom width height] style
subArrayIdx = {leftBottomCorner(2):rightTopCorner(2),...
    leftBottomCorner(1):rightTopCorner(1), leftBottomCorner(3):rightTopCorner(3)};

end
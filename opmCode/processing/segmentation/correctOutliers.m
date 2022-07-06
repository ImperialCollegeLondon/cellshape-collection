function [nucleusThreshold] = correctOutliers(nucleusThreshold)

nucleusThreshold = double(nucleusThreshold);
% nucleusThreshold(nucleusThreshold <= 0) = NaN;
nucleusThreshold(find(isoutlier(nucleusThreshold,'percentiles',[1 99]))) = NaN;

nucleusThreshold = fillmissing(nucleusThreshold,'movmedian',10); 
end
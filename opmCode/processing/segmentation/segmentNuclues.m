function [mask, volume] = segmentNuclues(volume, cellOrNucleus, ...
    Fullpath, Settings,iField, iRun, thresholdType, threshold)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here



switch thresholdType
    case 'manualThreshold'
        defaultThresh = threshold;
        activeContourSegmentation = false;
    case 'activeContour'
        defaultThresh = threshold;
        activeContourSegmentation = 'full';
    case 'oneLevelOtsu'
        defaultThresh = getOtsuThreshold(volume, 1, 1);
        activeContourSegmentation = false;
    case 'subROIac'
        defaultThresh = mean(volume(:)) + std(double(volume(:)));
        activeContourSegmentation = 'subROI';
    case 'activeContour_adaptThreshold'
        defaultThresh = mean(volume(:)) + std(double(volume(:)));
        activeContourSegmentation = 'full';
end

mask = makeNucleusMask(volume, defaultThresh, Settings, activeContourSegmentation);

%% Save maks
savepath = [Fullpath.savepath '\' cellOrNucleus '\field_' num2str(iField, '%04d')...
    '\run_' num2str(iRun, '%04d')];
mkdirNC(savepath)
saveTiffStack(savepath,volume)
savepath = [Fullpath.savepath '\' cellOrNucleus '_mask_' thresholdType...
    '\field_' num2str(iField, '%04d') '\run_' num2str(iRun, '%04d')];
mkdirNC(savepath)
saveTiffStack(savepath,mask)
end


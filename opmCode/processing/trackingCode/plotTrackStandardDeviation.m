function [] = plotTrackStandardDeviation(trackSTD, methodList, metric, iField, cellOrNucleus, Fullpath)

for ii = 1:size(trackSTD,2)
    tSTD{ii} = removeZeros(trackSTD(:,ii));
end

% plotSpread(tSTD)
makeBeehivePlot(tSTD, methodList, ['\sigma(' metric ')']);
savePath = [Fullpath.savepath '\field_' num2str(iField, '%04d') '\' cellOrNucleus];
mkdirNC(savePath)
saveas(gcf,[savePath '\timeStd.png'])
end

function [array] = removeZeros(array)
    array(array == 0) = [];
end
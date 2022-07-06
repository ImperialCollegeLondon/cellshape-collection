function [deltaMetric, normalisedDeltaMetric, trackSTD] = singleElementPlots(...
    BigStatsTable, metric, cellOrNucleus, methodList, iField, Fullpath)

tracks = unique(BigStatsTable.methodTrack);

xRange = [0 max(BigStatsTable.runNumber)];

yRange = [min(getfield(BigStatsTable, metric))...
    max(getfield(BigStatsTable, metric))];

savepath = [Fullpath.savepath '\field_' num2str(iField, '%04d') '\' cellOrNucleus '_trackGrpahs'];
mkdirNC(savepath)


for iTrack = tracks'
   TrackStats = getSingleCellStat(BigStatsTable, iTrack, 'timeTrack');
   figure()
   hold on
    for iMethod = 1:numel(methodList)
        MethodStats = getSingleCellStat(TrackStats, iMethod, 'methodNumber');
        plot(MethodStats.runNumber, getfield(MethodStats, metric), '-o')
        xlim(xRange)
        ylim(yRange)
        legend(methodList)
        title([cellOrNucleus ' ' num2str(iTrack)])
        box on
        
        if ~isempty(getfield(MethodStats, metric))
            if iTrack == 1
                deltaMetric{iMethod} = differenceBetweenFrames(...
                    getfield(MethodStats, metric));
                normalisedDeltaMetric{iMethod} =...
                    normalisedDifferenceBetweenFrames(getfield(MethodStats, metric));
            else
                deltaMetric{iMethod} = [deltaMetric{iMethod} ...
                    differenceBetweenFrames(getfield(MethodStats, metric))];
                normalisedDeltaMetric{iMethod} = [normalisedDeltaMetric{iMethod} ...
                    normalisedDifferenceBetweenFrames(getfield(MethodStats, metric))];
            end
        end
        
        trackSTD(iTrack, iMethod) = std(getfield(MethodStats, metric));
    end
    saveas(gcf,[savepath '\track_' num2str(iTrack, '%04d') '.png'])
end
end

function [deltaMetric] = differenceBetweenFrames(metricArray)
    previousMeasure = metricArray(1);

    metricArray(1) = [];
    deltaMetric = [];
    for ii = 1:numel(metricArray)
        deltaMetric(ii) = abs(metricArray(ii) - previousMeasure);
        previousMeasure = metricArray(ii);
    end
end

function [normalisedDeltaMetric] = normalisedDifferenceBetweenFrames(metricArray)
    normalisedDeltaMetric = differenceBetweenFrames(metricArray) / mean(metricArray);
end
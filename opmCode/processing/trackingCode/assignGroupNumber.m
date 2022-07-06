function [BigStatsTable] = assignGroupNumber(BigStatsTable)
% groupnumber is a number which links cells found by different methods
% across all time points

% make an array with matched group numbers
groupLUT = zeros(max(BigStatsTable.methodNumber), max(BigStatsTable.timeTrack));

groupNumber = 1;
for iRun = unique(BigStatsTable.runNumber)';
    % reduce to run
    runStats = getSingleCellStat(BigStatsTable, iRun, 'runNumber');
    % find each matching cell across methods for that time point
    for iMethodIndex = unique(runStats.methodTrack)';
        methodIndexStats = getSingleCellStat(runStats, iMethodIndex, 'methodTrack');

        flag = 0;
        % put a unique group number matching cells together based on the
        % segmentation method used and how it is tracked over time
        for iMethod = unique(methodIndexStats.methodNumber)';
            methodStats = getSingleCellStat(methodIndexStats, iMethod, 'methodNumber');
            if groupLUT(iMethod, methodStats.timeTrack) == 0 % not already asigned
                groupLUT(iMethod, methodStats.timeTrack) = groupNumber;
                flag = 1;
            end   
        end

        if flag % increment group number
            groupNumber = groupNumber + 1;
        end 
    end
end

groupNumber = zeros(size(BigStatsTable.runNumber));
parfor ii = 1:size(BigStatsTable,1)
    tempTable = BigStatsTable(ii,:);
    groupNumber(ii) = groupLUT(tempTable.methodNumber, tempTable.timeTrack);
end

BigStatsTable.groupNumber = groupNumber;
end
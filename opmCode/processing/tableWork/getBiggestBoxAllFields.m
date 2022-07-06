% folder = 'G:\Data\CRUK MDPA\dotphotonCompressed\temp\20190614_CRUK15\main488_642\19-06-14\15-23-19\cst4\Segmentation\stats\cell_twoLevelOtsu_byTimePoint';

function [boxSize] = getBiggestBoxAllFields(folder)

fieldList = dir([folder '\field_*.mat']);

for iField = 1:numel(fieldList)
    load([fieldList(iField).folder '\' fieldList(iField).name]);
    BigStatsTable = vertcat(Stats{:});
    boxSize(:,iField) = getBiggestBox(BigStatsTable)';
end

boxSize = max(boxSize,[],2);

end
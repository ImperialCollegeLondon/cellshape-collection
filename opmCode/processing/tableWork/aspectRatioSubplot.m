function [rows, columns] = aspectRatioSubplot(nPlots)
    rows = ceil(sqrt(nPlots));
    columns = ceil(nPlots/ rows);
end
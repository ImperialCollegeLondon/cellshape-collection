function clusterTable = importClusterList(filename, dataLines)
%IMPORTFILE Import data from a text file
%  ALL = IMPORTFILE(FILENAME) reads data from text file FILENAME for the
%  default selection.  Returns the data as a table.
%
%  ALL = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  all = importfile("G:\Data\CRUK MDPA\dotphotonCompressed\temp\20190614_CRUK15\main488_642\19-06-14\15-23-19\cst4\activeContourAndOtusSegmentation\stats\pcaData\clusterData\all.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 04-Jan-2021 10:18:58

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 17);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "runNumber", "timeTrack", "fieldNumber", "Row", "Column", "Treatment", "cellNumber", "serialNumber", "yDim", "xDim", "zDim", "cluster"];
opts.SelectedVariableNames = ["runNumber", "timeTrack", "fieldNumber", "Row", "Column", "Treatment", "cellNumber", "serialNumber", "yDim", "xDim", "zDim", "cluster"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "double", "double", "double", "categorical", "double", "categorical", "categorical", "categorical", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Row", "Treatment", "cellNumber", "serialNumber"], "EmptyFieldRule", "auto");

% Import the data
clusterTable = readtable(filename, opts);

end
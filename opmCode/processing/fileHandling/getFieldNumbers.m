function [fieldNumbers] = getFieldNumbers(fieldNames)
%getFieldNumbers outputs a vector containing the numbers corresponding to
%the fields found in fieldNames

temp = regexp(fieldNames,'\d*','Match'); % gets the numbers only from the field names
temp = cellfun(@string,temp); % needs to be converted to string before converting to number
fieldNumbers = cellfun(@str2num,temp);
end

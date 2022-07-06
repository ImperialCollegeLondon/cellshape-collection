function [B, I] = sorti(A, varargin)
% [B, I] = sorti(A, varargin)
%
% A - Cell array of strings
% B - Sorted output. It's case insensitive as in the operative system. Matlab 
%     sort function uses ASCII dictionary order (first upper case).
% I - Same size as A and describes the rearrangement of the elements along the 
%     sorted dimension 
%
% Case insensitive sorting of cell array. Takes the same input arguments 
% as SORT
%
% gP 14/1/2013
[~, I] = sort(lower(A), varargin{:});
B = A(I);               % To keep upper cases
end
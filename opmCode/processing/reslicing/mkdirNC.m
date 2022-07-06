function [] = mkdirNC(path)
%mkdirNC creates a directory if it does not exit. If it exists does nothing

if ~exist(path,'dir')
    mkdir(path)
end

end


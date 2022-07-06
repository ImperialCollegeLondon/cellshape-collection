function p = readParams(path)
% reads the image parameters file and outputs them as a struct
% path = 'H:\2015\15-12-10\parameters.txt';

% fields = dlmread(path,'\n');

fileID = fopen(path,'r');
clear('p')

tline = fgets(fileID );
while ischar(tline)
%     disp(tline);
    C = strsplit(tline,';');
    Cname = C{1};
    Cname(ismember(Cname,' ,.:;!')) = [];
%     if idx < 8
        p.(Cname) = cellfun(@str2num,C(2:end));
%     else
%         p.(Cname) = cellfun(@str2num,C(2:end-1));
%     end
    tline = fgets(fileID);    
end
% A = fscanf(fileID,formatSpec)
% n_run ; 30
% run_interval ; 10
% trg_dist ; 2.0
% exp1 ; 2
% exp2 ; 2
% scan_speed ; 0.1
% travel_speed ; 10.0
% x_pos ;  -17876 ; -18226 ; -31285 ; -32878 ; -46279 ; -46269 ; -59591 ; -58880 ; -60346 ; -58005 ; -48034 ; -45187 ; -35123 ; -34817 ; -22383 ; -21582 ;
%  y_bg ;  -50111 ; -48689 ; -48923 ; -48775 ; -48993 ; -48998 ; -48819 ; -45199 ; -34465 ; -37028 ; -37399 ; -35800 ; -35938 ; -35606 ; -36994 ; -38863 ;
%  y_end ;  -49721 ; -48385 ; -48501 ; -48340 ; -48618 ; -48617 ; -48401 ; -44838 ; -34101 ; -36670 ; -36897 ; -35330 ; -35581 ; -35114 ; -36675 ; -38516 ;
%  f_pos ;  -2361850 ; -2523700 ; -2297400 ; -2297400 ; -2170350 ; -2170350 ; -2011600 ; -2011600 ; -2011600 ; -2011600 ; -2189900 ; -2228750 ; -2339250 ; -2339250 ; -2408950 ; -2408950 ;
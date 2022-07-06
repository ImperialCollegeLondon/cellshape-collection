function [ montage ] = mipSegmented( data, gridWeight )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    if nargin > 1
        gridOn = true;
    else
        gridOn = false;
    end
    
    gridValue = 2^16;%max(data(:));

    [nx ny nz] = size(data);

      xy_im = squeeze(max(data,[],3)); % size ny nx
      zy_im = squeeze(max(data,[],1)); % size nz ny
      zx_im = squeeze(max(data,[],2)); % size nz nx
      
      if gridOn
          xy_im = padarray(xy_im, [gridWeight, gridWeight], gridValue);
          zy_im = padarray(zy_im, [gridWeight, gridWeight], gridValue);
          zx_im = padarray(zx_im, [gridWeight, gridWeight], gridValue);
      end
      
      % build MIP
      montage = [zx_im'
          xy_im'];
      
      zy_im = [ones(size(zy_im,2), size(zy_im,2)) * 0 % gridValue - Chris does not want white boxes
          zy_im];
      
      montage = [zy_im montage];
      if gridOn
          montage = padarray(montage, [gridWeight, gridWeight], gridValue);
      end

%       x_ex=floor(0.05*(nz+nx));
%       y_ex=floor(0.05*(nz+nx));
% 
%       final(nz+y_ex+(1:ny),1:nz) = zy_im; % size ny / nz
%       final(1:nz,nz+x_ex+(1:nx)) = zx_im'; %size nz / nx
%       final(nz+y_ex+(1:ny),nz+x_ex+(1:nx)) = xy_im'; 

    %   if nx >= ny
    %         montage = final;
    %     else
    %         montage = final';
    %     end

%     montage = final;

end
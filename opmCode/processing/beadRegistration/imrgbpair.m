function [] = imrgbpair(img1,img2,M1,M2)

rgb = zeros([size(img1) 3]);
    rgb(:,:,1) = img1/M1;
    rgb(:,:,2) = img2/M2;
imagesc(rgb), axis equal tight
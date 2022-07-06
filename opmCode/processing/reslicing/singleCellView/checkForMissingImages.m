folder = 'G:\Data\CRUK MDPA\dotphotonCompressed\temp\20190614_CRUK15\main488_642\19-06-14\15-23-19\cst4\Segmentation\mask\orthoMaskMontage\201106_085413';
listImages = {dir([folder '\*_channel_0001.tif']).name};

for ii = 1:numel(listImages)
    str = regexp(listImages{ii},'_','split');
    runNumber(ii) = str2double(str{2});
    if runNumber(ii) ~= ii
        ii
    end
end

function[reassignFolder, tReassign, tCompress] =...
    dotphotonCompressSaveAsSeperateFiles(subfolder, SN, reassignedRoot, compressRoot)

%     %% copy timestamp
%     t = tic;
% %     timestampGetter([root, subfolder]);
% %     copyNonTiffs([root, subfolder], [compressRoot subfolder]);
%     [timeStampRaw, frame] = resaveImageInImageJAndGetTimeStamp([root subfolder]);
%     tTimestamp = toc(t);

    %% Noise reassignment
    [reassignFolder, tReassign] = generateNoiseReassignedImages(...
        reassignedRoot, 'R:\seperateImages', [], SN);
    delete(['R:\seperateImages\*'])
    %% Compression
    tCompress = compressReassignedData(compressRoot, subfolder, reassignFolder);
end
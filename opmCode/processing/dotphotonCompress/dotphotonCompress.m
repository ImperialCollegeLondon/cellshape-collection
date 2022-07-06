function[reassignFolder, tReassign, tCompress, tTimestamp] =...
    dotphotonCompress(root, subfolder, SN, reassignedRoot, compressRoot)

    %% copy timestamp
    t = tic;
    timestampGetter([root, subfolder]);
    copyNonTiffs([root, subfolder], [compressRoot subfolder]);
    tTimestamp = toc(t);

    %% Noise reassignment
    [reassignFolder, tReassign] = generateNoiseReassignedImages(...
        reassignedRoot, root, subfolder, SN);

    %% Compression
    tCompress = compressReassignedData(compressRoot, subfolder, reassignFolder);
end
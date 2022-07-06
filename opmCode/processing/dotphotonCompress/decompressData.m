function [] = decompressData(decompressedFolder, compressedFolder)
    command =['jetraw decompress -d "' decompressedFolder '" "' compressedFolder '"'];
    status = system(command);
end
function [tCompress] = compressReassignedData(compressRoot, subfolder, reassignFolder)

t = tic;
compressionSerialCommand([compressRoot subfolder], reassignFolder);
tCompress = toc(t);

end

function [] = compressionSerialCommand(compressedFolder, reassignFolder)
    command =['jetraw compress -d "' compressedFolder '" "' reassignFolder '"'];
    status = system(command);
end
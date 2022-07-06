function [volume] = loadDotPhoton(folderRaw, decompressedFolder)
    decompressData(decompressedFolder, folderRaw)
    volume = loadMicroManagerVolume2020(decompressedFolder);
    delete([decompressedFolder '\*'])
end
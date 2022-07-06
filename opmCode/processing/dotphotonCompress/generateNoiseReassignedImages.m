function [reassignFolder, tReassign] = generateNoiseReassignedImages(...
    reassignedRoot, root, subfolder, SN)

%     reassignFolder = [reassignedRoot num2str(randi([0 1e7]))];
    reassignFolder = [reassignedRoot '\reassigned'];
    t = tic;
    serialCommandReassign(SN, reassignFolder, [root subfolder]);
    tReassign = toc(t);
end

function[] = serialCommandReassign(serialNumber, reassignedFolder,...
    imageFolder)
    command =['dpcore -i ' serialNumber ' -d "'...
                reassignedFolder '" "' imageFolder '"'];
    status = system(command);
end
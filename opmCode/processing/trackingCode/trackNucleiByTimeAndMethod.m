function [NucleusStats] = trackNucleiByTimeAndMethod(NucleusStats, methodList)

for iRun = 1:size(NucleusStats,1)
    NucleusStats(iRun,:) = getMethodTrackStats(NucleusStats(iRun,:), methodList);
end
for iMethod = 1:size(NucleusStats,2)
    NucleusStats(:,iMethod) = getRunTrackedStats(NucleusStats(:,iMethod));
end

end
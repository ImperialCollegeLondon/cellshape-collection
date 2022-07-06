function [] = convexHullPlot(pcaTable)
[g ID] = findgroups(pcaTable.cluster);
for iCluster = unique(g)'
    clusterTable = pcaTable(g==iCluster,:);
    P = [clusterTable.principalComponent1, clusterTable.principalComponent2];
    k = convhull(P);
    plot(P(k,1),P(k,2));
    hold all
end
end
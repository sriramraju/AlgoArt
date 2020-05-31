function mstTree = getMSTPrims( inPts )

triangles = delaunay(inPts(:,1),inPts(:,2));
% trimesh(triangles,inPts(:,1),inPts(:,2),zeros(size(inPts(:,1))))

allindices = unique(triangles(:));
lenIds = length(allindices);

node = ceil(lenIds*rand(1));
mstTree = [nan node];

triangleOrig = triangles;
nodesLeft = allindices;

while(~isempty(nodesLeft))
%     [node length(nodesLeft)]
    [row,~] = find(triangles == node);
    triangles(triangles == node) = 0;
    ptsIndices = unique(triangles(row,:));
    
    ptsIndices(ptsIndices == 0) = [];
    
    if isempty(ptsIndices) || isPresentinTree(mstTree(1:end-1),node)
%        disp('Move on');
       node = nodesLeft(1);
       triangles = triangleOrig;
       mstTree = [mstTree nan];
    else
        node = getNextNode(ptsIndices,node, inPts);
    end
    mstTree = [mstTree node];
    nodesLeft(nodesLeft == node) = [];
end

mstTree = [mstTree nan];

end

function out = isPresentinTree(crntTree,node)

if isempty(find(crntTree == node, 1))
    out = 0;
else
    out = 1;
end

end

function out = getNextNode(cnctIds,nodeId, allPts)

cnctPts = allPts(cnctIds,:);
nodePt = allPts(nodeId,:);

len = size(cnctPts,1);
absDiff = abs(cnctPts - repmat(nodePt,len,1));
distVals = sum((absDiff.^2),2);
pos = find(distVals == min(distVals));

out = cnctIds(min(pos));
end
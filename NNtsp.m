function OUTcnctPts = NNtsp(inPts)

OUTcnctPts(1,:) = inPts(1,:);
remainingPts = inPts;
remainingPts(1,:) = [];
for i=1:size(inPts,1)-1
    
    anchorPt = OUTcnctPts(end,:);
    ptIndex = getPointwithMinDistance(anchorPt,remainingPts);
    OUTcnctPts(i+1,:) = remainingPts(ptIndex(1),:);
    remainingPts(ptIndex(1),:) = [];
    
end

end

function out = getPointwithMinDistance(pt, restPoints)

for i=1:size(restPoints,1)
    distVals(i) = getDistance(pt, restPoints(i,:));
end

out = find(distVals == min(distVals));

end

function dist = getDistance(ptA, ptB)

dist = sqrt((ptA(1)-ptB(1))^2 + (ptA(2)-ptB(2))^2);

end

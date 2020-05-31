function showImage = getStippledImage(inPath)

close all;

% Create stippled images

% Parameters
numPoints = 500;
maxIter = 10;
searchDim = 20;
minDistbwPts = 20;

img = imread(inPath);
imgGray = 255 - rgb2gray(img);

[m, n] = size(imgGray);

if numPoints > m*n
    disp('Too many points');
end

pointsLocs = ceil([m*rand(numPoints,1) n*rand(numPoints,1)]);
isSufficent = zeros(numPoints,1);

displayPointCloud(imgGray,pointsLocs,m,n);

for i = 1:maxIter
    disp(i);
    for j = 1:numPoints
        if isSufficent(j) == 0
            
            refPt = pointsLocs(j,:);
            newPt = searchAround(imgGray, refPt, searchDim);
            if isnan(newPt(1))
                isSufficent(j) = 1;
            end
            % Move only if not close
            pointsLocs(j,:) = newPt;
%             if isNotTooClose(newPt,pointsLocs,minDistbwPts)
%                 pointsLocs(j,:) = newPt;
%             else
%                 pointsLocs(j,:) = ceil([m*rand(1,1) n*rand(1,1)]);
%             end
            
        end
    end
    displayPointCloud(imgGray,pointsLocs,m,n);
end


end

function outPt = searchAround(imageIn, pt, dim)

[subImage, strtpt] = getSectionImage(imageIn,pt,dim);

[mSub, nSub] = size(subImage);

weightedMatrix = double(subImage).*repmat([1:mSub]',1,nSub);
subPt(1) = sum(weightedMatrix(:))/sum(subImage(:));
weightedMatrix = double(subImage).*repmat(1:nSub,mSub,1);
subPt(2) = sum(weightedMatrix(:))/sum(subImage(:));

% if isnan(subPt(1))
%     disp('Points Nan');
% end

outPt = strtpt + round(subPt);

end

function [outImage, strtPtImage] = getSectionImage(img,rPt,rDim)

[endM, endN] = size(img);

% for X only
strtX = rPt(1) - rDim;
endX = rPt(1) + rDim;
if rPt(1) - rDim < 1
    strtX = 1;
end
if rPt(1) + rDim > endM
    endX = endM;
end

% for Y only
strtY = rPt(2) - rDim;
endY = rPt(2) + rDim;
if rPt(2) - rDim < 1
    strtY = 1;
end
if rPt(2) + rDim > endN
    endY = endN; 
end

outImage = img(strtX:endX,strtY:endY);
strtPtImage = [strtX strtY];

end

function out = getDistance(pt1, pt2)

out = sqrt(sum((pt1-pt2).^2));

end

function displayPointCloud(img,pointsIn,m,n)

figure;
imshow(img);hold on;
% dispImage = zeros(m,n);
% dispImage(pointsIn) = 1;
% imshow(dispImage);
plot(pointsIn(:,2),pointsIn(:,1),'*');
hold off;
end

function out = isNotTooClose(nPt,allPts, threshValue)

out = 0;
m = size(allPts,1);
nPtMatrix = [nPt(1)*ones(m,1) nPt(2)*ones(m,1)];
sqrDiffs = (abs(nPtMatrix - allPts)).^2;
distFromPt = sum(sqrDiffs');

if min(distFromPt) > threshValue
    out = 1;
end

end
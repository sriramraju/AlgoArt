function out = linesIntersect(fourPoints)

out = 0;

if length(fourPoints) == 4
    line1 = fourPoints(1:2,:);
    line2 = fourPoints(3:4,:);
    
    [m1,c1] = getSlopeNintercept(line1);
    [m2,c2] = getSlopeNintercept(line2);

    if differentSides(m1,c1,line2) && differentSides(m2,c2,line1)
        out = 1;
    end
end

end

function [m,c] = getSlopeNintercept(pts)
    m = (pts(1,2)-pts(2,2))/(pts(1,1)-pts(2,1));
    
    c = pts(1,2) - m*(pts(1,1));
end

function outDifferentSides = differentSides(m,c,pts)

outDifferentSides = 0;

sidePt1 = sign(pts(1,2) - m*pts(1,1) - c);
sidePt2 = sign(pts(2,2) - m*pts(2,1) - c);

if sidePt2 ~= sidePt1
    outDifferentSides = 1;
end

end
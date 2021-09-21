function res = pointInRect(x, y, rect)
%POINTINRECT Summary of this function goes here
%   Detailed explanation goes here
res = x > rect(1) && x < rect(3) && y > rect(2) && y < rect(4);


end


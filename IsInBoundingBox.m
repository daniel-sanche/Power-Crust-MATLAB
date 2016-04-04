function [inBox] = IsInBoundingBox(pts, box)
% checks whether a set of points are within a bounding box
%
% inputs:
% pts - the points to check
% box - the box we are comparing the points to, 
%       specified as a list of corrdinate values
% 
% outputs:
% inBox - a logical vector representing whether each point in 
% pts is in the bounding box


  [~, cols] = size(box);
  inBox = true(length(pts), 1);
  for i=1:cols
    ptDim = pts(:,i);
    maxVal = max(box(:,i));
    minVal = min(box(:,i));
    lessThanMax = ptDim < maxVal;
    moreThanMin = ptDim > minVal;
    matchesBoth = and(lessThanMax, moreThanMin);
    inBox = and(inBox, matchesBoth);
  end
end

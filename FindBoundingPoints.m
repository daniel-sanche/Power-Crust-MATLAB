function [ boundsPoints ] = FindBoundingPoints( points, multiplier )
% To avoid infinitely large voroni cells, we find the bounding points away
% from the regular point cloud. The number of bounding points returned will
% depend on the number of dimensions
%
% inputs: 
% points - the point cloud we are looking for bounding points for
% multiplier - the distance away from the point cloud to put the bounds at
%
% outputs:
% boundingPoints - a matrix of points, where each row is a point, and each
%                 column is a dimension

[rows, cols] = size(points);

boundsPoints = zeros(2^cols,cols);

for i=1:cols
   maxPt = max(points(:,i)); 
   minPt = min(points(:,i));
   meanPt = mean(points(:,i));
   diffMax = maxPt - meanPt;
   diffMin = minPt - meanPt;
   maxPt = maxPt + diffMax*multiplier;
   minPt = minPt + diffMin*multiplier;
   
   numRepeats = 2^(i-1);
   j = 1;
   while j<length(boundsPoints)
       for k=1:numRepeats
           boundsPoints(j,i) = maxPt;
           j=j+1;
       end
       for k=1:numRepeats
           boundsPoints(j,i) = minPt;
           j=j+1;
       end
   end
end
end


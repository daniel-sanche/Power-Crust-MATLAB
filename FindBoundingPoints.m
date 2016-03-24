function [ boundsPoints ] = FindBoundingPoints( points )
%To avoid infinitely large voroni cells, we find the 8 bounding points of
%the point cloud.

[rows, cols] = size(points);

boundsPoints = zeros(2^cols,cols);

for i=1:cols
   maxPt = max(points(:,i)); 
   minPt = min(points(:,i));
   meanPt = mean(points(:,i));
   diffMax = maxPt - meanPt;
   diffMin = minPt - meanPt;
   maxPt = maxPt + diffMax*4;
   minPt = minPt + diffMin*4;
   
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


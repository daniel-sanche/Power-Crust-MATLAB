function [ bounds ] = FindBoundingPoints( points )
%To avoid infinitely large voroni cells, we find the 8 bounding points of
%the point cloud.

maxX = max(points(:,1));
minX = min(points(:,1));
maxY = max(points(:,2));
minY = min(points(:,2));
maxZ = max(points(:,3));
minZ = min(points(:,3));

meanX = mean(points(:,1));
meanY = mean(points(:,2));
meanZ = mean(points(:,3));

diffMaxX = maxX - meanX
diffMaxY = maxY - meanY
diffMaxZ = maxZ - meanZ
diffMinX = minX - meanX
diffMinY = minY - meanY
diffMinZ = minZ - meanZ

%The paper suggests putting them at 5 times the minimal bounding box
maxX = maxX + diffMaxX*4
maxY = maxY + diffMaxY*4
maxZ = maxZ + diffMaxZ*4
minX = minX + diffMinX*4
minY = minY + diffMinY*4
minZ = minZ + diffMinZ*4


bounds = [maxX,maxY,maxZ; maxX,maxY,minZ; maxX,minY,maxZ; maxX,minY,minZ;
          minX,maxY,maxZ; minX,maxY,minZ; minX,minY,maxZ; minX,minY,minZ];

end


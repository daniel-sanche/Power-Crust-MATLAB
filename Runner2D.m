%This file creates a 2D point cloud, and feeds it into PowerCrust.m

%load the built in MATLAB teapot point cloud
ptCloud = pcread('teapot.ply');
points = double(ptCloud.Location);

%flatten it into 2D
ptCloudA = points(:,1:2:3);
ptCloudB = points(:,2:3);
ptCloudC = points(:,1:2);

%we can use any of the above flattenings as out point cloud
points = ptCloudA;

%remove interior points
k = boundary(points(:,1),points(:,2),1);
points = points(k,:);

%plot original point cloud
figure;
plot(points(:,1),points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
title('original input');

%run Power Crust
PowerCrust(points);
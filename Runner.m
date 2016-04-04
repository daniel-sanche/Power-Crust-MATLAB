%This class just creates a point cloud, and feeds it into PowerCrust.m

%load the built in MATLAB teapot point cloud
ptCloud = pcread('teapot.ply');

ptCloud = pcdownsample(ptCloud,'gridAverage',0.3);

points = ptCloud.Location;

%plot original point cloud
figure;
pcshow(ptCloud);
title('original input');

%run Power Crust
PowerCrust(points);
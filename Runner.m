ptCloud = pcread('teapot.ply');
points = double(ptCloud.Location);

ptCloudA = points(:,1:2:3);
ptCloudB = points(:,2:3);
ptCloudC = points(:,1:2);

points = ptCloudA;

k = boundary(points(:,1),points(:,2),1);
points = points(k,:);

figure;
plot(points(:,1),points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
title('original input');

PowerCrust(points);
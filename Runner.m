ptCloud = pcread('teapot.ply');
points = double(ptCloud.Location);

points = points(:,1:2:3);

plot(points(:,1),points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
k = boundary(points(:,1),points(:,2),1);
points = points(k,:);

figure;
plot(points(:,1),points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
title('original input');

PowerCrust(points);
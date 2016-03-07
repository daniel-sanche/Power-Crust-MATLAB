ptCloud = pcread('teapot.ply');
%pcshow(ptCloud)


points = unique(ptCloud.Location, 'rows');

x = points(:,1);
y = points(:,2);
z = points(:,3);
 

[vx, vy] = GenerateVoroni(x, y, z);
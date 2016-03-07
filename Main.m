ptCloud = pcread('teapot.ply');
%pcshow(ptCloud)


points = unique(ptCloud.Location, 'rows');
points = [points ; FindBoundingPoints(points)];

x = points(:,1);
y = points(:,2);
z = points(:,3);
 

[verts, cells] = GenerateVoroni(x, y, z);
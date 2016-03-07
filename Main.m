ptCloud = pcread('teapot.ply');
%pcshow(ptCloud)


points = unique(ptCloud.Location, 'rows');
points = [points ; FindBoundingPoints(points)];

x = points(:,1);
y = points(:,2);
z = points(:,3);
 

[verts, cells] = GenerateVoroni(x, y, z);
%remove the last 8 cells, because they correspond to the bounding points
cells = cells(1:length(cells)-8,:);

%find the poles of each cell
poleIdxMat = FindPoles( verts, cells, points );
poleVerts = verts(poleIdxMat, :);
poleRadMat = FindPolarBalls(poleVerts, points);

[PD, PDinf] = powerDiagramWrapper(poleVerts, poleRadMat);
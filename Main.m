%ptCloud = pcread('teapot.ply');

points = GenerateCircle(50, 1);

points = unique(points, 'rows');
points = [points ; FindBoundingPoints(points)];
points = double(points);
%plot3(points(:,1),points(:,2),points(:,3),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none') 
[verts, cells] = voronoin(points);

%remove the last 8 cells, because they correspond to the bounding points
cells = cells(1:length(cells)-4,:);

%find the poles of each cell
[poleIdxMat, poleRadMat] = FindPoles( verts, cells, points );
poleVerts = verts(poleIdxMat, :);
[poleVerts, keptIdx] = unique(poleVerts, 'rows');
poleRadMat = poleRadMat(keptIdx);

%find the power diagram
[PD, PDinf] = powerDiagramWrapper(poleVerts, poleRadMat);

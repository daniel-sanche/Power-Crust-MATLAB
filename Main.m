ptCloud = pcread('teapot.ply');
points = double(ptCloud.Location);

points = points(:,1:2:3);

plot(points(:,1),points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
k = boundary(points(:,1),points(:,2),1);
points = points(k,:);

plot(points(:,1),points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');

%points = GenerateCircle(500, 1);

points = unique(points, 'rows');
points = [points ; FindBoundingPoints(points, 10)];
points = double(points);
[verts, cells] = voronoin(points);
DisplayVoronoi(cells, verts, points);

%remove the last 4 cells, because they correspond to the bounding points
cells = cells(1:length(cells)-4,:);
points = points(1:length(points)-4,:);

%find the poles of each cell
[poleVerts, poleRadMat, sampleIdxForPole, oppositePoleIdx] = FindPoles( verts, cells, points );

DisplayPolarBalls(poleVerts, poleRadMat);


%find the power diagram
[PD, PDinf] = powerDiagramWrapper(poleVerts, poleRadMat .^2);
hold on;
plot(points(:,1), points(:,2),'Marker','.','MarkerEdgeColor','g','MarkerSize',10, 'LineStyle', 'none');
hold off;

%label points (inside/outside)
labels = LabelPoles(poleVerts, points, poleRadMat, sampleIdxForPole, oppositePoleIdx);

%generage the mesh
[meshVerts, meshEdges] = FindSurfaceMesh(labels, PD{2}, PD{1}, poleVerts, poleRadMat);
[MedialAxis, MAT] = FindMedialAxis(poleVerts, labels, PD{1});

DisplayMesh(meshEdges);
DisplayMedialAxis(MedialAxis,MAT);
Disp('done');
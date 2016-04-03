%ptCloud = pcread('teapot.ply');

points = GenerateCircle(50, 1);

points = unique(points, 'rows');
points = [points ; FindBoundingPoints(points, 4)];
points = double(points);
[verts, cells] = voronoin(points);
DisplayVoronoi(cells, verts, points);

%remove the last 4 cells, because they correspond to the bounding points
cells = cells(1:length(cells)-4,:);
points = points(1:length(points)-4,:);

%find the poles of each cell
[poleIdxMat, poleRadMat] = FindPoles( verts, cells, points );
poleVerts = verts(poleIdxMat, :);
[poleVerts, keptIdx] = unique(poleVerts, 'rows');
poleRadMat = poleRadMat(keptIdx);

%faking radius'
%poleRadMat = 100*rand(381,1)
DisplayPolarBalls(poleVerts, poleRadMat);

%find the power diagram
[PD, PDinf] = powerDiagramWrapper(poleVerts, poleRadMat);
vertSet = PD{1};
figure;
hold on;
for i=1:length(poleVerts)
    verts = vertSet{i};
    plot(poleVerts(i,1), poleVerts(i,2),'Marker','.','MarkerEdgeColor','b','MarkerSize',10, 'LineStyle', 'none');
    plot(verts(:,1), verts(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
   % pause(0.1)
end
hold off;

%label points (inside/outside)
labels = LabelPoles(poleVerts, points);
labels
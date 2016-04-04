function [MeshVerts,MeshEdges,MedialAxis,MAT] = PowerCrust(points)
    points = unique(points, 'rows');
    points = [points ; FindBoundingPoints(points, 10)];
    points = double(points);
    [verts, cells] = voronoin(points);

    %remove the last 4 cells, because they correspond to the bounding points
    cells = cells(1:length(cells)-4,:);
    points = points(1:length(points)-4,:);

    %find the poles of each cell
    [poleVerts, poleRadMat, sampleIdxForPole, oppositePoleIdx] = FindPoles( verts, cells, points );

    %find the power diagram
    [PD, ~] = powerDiagramWrapper(poleVerts, poleRadMat .^2);
    hold on;
    title('Power Diagram');
    plot(points(:,1), points(:,2),'Marker','.','MarkerEdgeColor','g','MarkerSize',10, 'LineStyle', 'none');
    hold off;

    %label points (inside/outside)
    labels = LabelPoles(poleVerts, points, poleRadMat, sampleIdxForPole, oppositePoleIdx);

    %generage the mesh
    [MeshVerts, MeshEdges] = FindSurfaceMesh(labels, PD{2}, PD{1}, poleVerts, poleRadMat);
    [MedialAxis, MAT] = FindMedialAxis(poleVerts, labels, PD{1});

    DisplayMesh(MeshEdges);
    DisplayMedialAxis(MedialAxis,MAT);
end
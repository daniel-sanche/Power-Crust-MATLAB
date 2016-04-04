function [MeshVerts,MeshEdges,MedialAxis,MAT] = PowerCrust(points)
    %% Setup
    
    points = unique(points, 'rows');
    points = double(points);

    
    %% Step 1: Voronoi Diagram
    
    %add boundary points to avoid infinite voronoi cells
    boundPts = FindBoundingPoints(points, 10);
    points = [points ; boundPts];
    
    %create a voronoi diagram from the points
    [verts, cells] = voronoin(points);

    %remove the last 4 cells, because they correspond to the bounding points
    numBounds = length(boundPts);
    cells = cells(1:length(cells)-numBounds,:);
    points = points(1:length(points)-numBounds,:);

    %% Step 2: Find Poles

    [poleVerts, poleRadMat, sampleIdxForPole, oppositePoleIdx] = FindPoles( verts, cells, points );

    %% Step 3: Compute Power Diagram of Poles
    [PD, ~] = powerDiagramWrapper(poleVerts, poleRadMat .^2);
    hold on;
    title('Power Diagram');
    plot(points(:,1), points(:,2),'Marker','.','MarkerEdgeColor','g','MarkerSize',10, 'LineStyle', 'none');
    hold off;

    %% Step 4: Label Poles
    labels = LabelPoles(poleVerts, points, poleRadMat, sampleIdxForPole, oppositePoleIdx);

    %% Step 5: Generate Outputs
    [MeshVerts, MeshEdges] = FindSurfaceMesh(labels, PD{2}, PD{1}, poleVerts, poleRadMat);
    [MedialAxis, MAT] = FindMedialAxis(poleVerts, labels, PD{1});

    DisplayMesh(MeshEdges);
    DisplayMedialAxis(MedialAxis,MAT);
end
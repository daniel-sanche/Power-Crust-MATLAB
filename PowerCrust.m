function [MeshVerts,MeshEdges,MedialAxis,MAT] = PowerCrust(points)
    %This algorithm is an implementation of the Powert Crust algorithm
    %described by Nina Amenta, Sunghee Choi, and  Ravi Krishna Kolluri
    %from the University of Texas at Austin.
    %The algorithm takes in a 2D or 3D point cloud as input, and returns a
    %surface mesh, and the medial axis transform
    %
    % inputs:
    % points - a hallow 2D or 3D point cloud of some object
    %          should be nx2, where each row is a distinct point
    %
    % outputs:
    % MeshVerts - a list of all the vertices on the output surface mesh
    % MeshEdges - a list of edges between the meshVerts, creating a solid polygonal mesh
    %             represented by a cell array, where each cell contains two vertices that can be joined with a line
    % MedialAxis - the set of points representing the medial axis of the point cloud
    % MAT - the medial axis transform. Represents a set of edges between MedialAxis points
    
    
    %% Setup
    
    points = unique(points, 'rows');
    points = double(points);
    [~,dim] = size(points);
    if(dim~=2 && dim~=3)
       error('point cloud must be 2D or 3D'); 
    end
    
    %% Step 1: Voronoi Diagram
    disp('Finding Voronoi Diagram');
    %add boundary points to avoid infinite voronoi cells
    boundPts = FindBoundingPoints(points, 5);
    points = [points ; boundPts];
    
    %create a voronoi diagram from the points
    [verts, cells] = voronoin(points);

    %remove the last cells, because they correspond to the bounding points
    numBounds = length(boundPts);
    cells = cells(1:length(cells)-numBounds,:);
    points = points(1:length(points)-numBounds,:);

    %% Step 2: Find Poles
    disp('Finding Poles');
    [poleVerts, poleRadMat, sampleIdxForPole, oppositePoleIdx] = FindPoles( verts, cells, points );

    %% Step 3: Compute Power Diagram of Poles
    disp('Finding Power Diagram');
    [PD, ~] = powerDiagramWrapper(poleVerts, poleRadMat .^2);

    %% Step 4: Label Poles
    disp('Labeling Poles');
    labels = LabelPoles(poleVerts, points, poleRadMat, sampleIdxForPole, oppositePoleIdx);

    %% Step 5: Generate Outputs
    disp('Generating Mesh/Medial Axis');
    boundingBox = FindBoundingPoints(points, 1);
    [MeshVerts, MeshEdges] = FindSurfaceMesh(labels, PD{dim}, PD{1}, poleVerts, poleRadMat, boundingBox);
    [MedialAxis, MAT] = FindMedialAxis(poleVerts, labels, PD{1});

    DisplayMesh(MeshEdges);
    DisplayMedialAxis(MedialAxis,MAT);
end
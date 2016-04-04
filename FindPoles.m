function [ poleVerts, poleRadMat, sampleIdxForPole, oppositePoleIdx] = FindPoles( verts, cells, points )
%finds the set of poles for the point cloud, given the voronoi cells and vertices
%the poles are a subset of the voronoi vertices, that represent the two most extreme points 
%on either side of each voronoi cell. There is typically one pole inside the mesh, and one outside, 
%but they will be labeled later
%
%inputs:
%verts - the voronoi vertices of the point cloud
%cells - the voronoi cells of the point cloud
%points - the original input points
%outputs:
%poleVerts - a list of the vertices of the poles. Each row represents a distinct point, and the 
%            columns represent the coordinate values
%poleRadMat - a list of the radius for each pole. Represents the distance from the pole
%             to its nearest point in the point cloud
%sampleIdxForPole - a list representing the original point associated with each pole, 
%                   given as an index into the points list
%oppositePoleIdx - a list representing the opposite pole for each pole, 
%                  given as an index into the poleVerts list

    %initalize arrays
    polesMat = ones(length(cells)*2, 1) *-1;
    poleRadMat = ones(length(cells)*2, 1) *-1;
    sampleIdxForPole = ones(length(cells)*2,1) *-1;
    oppositePoleIdx = ones(length(cells)*2,1) *-1;
    
    %look through each voronoi cell, finding the extreme vertices and adding them to the pole list
    j = 1;
    for i =1:length(cells)
        thisPoint = points(i,:);
        thisCell = cells{i};
        cellsVertices = verts(thisCell,:); 
        
        %find the furthest voroni vertex
        thisPointMat =  repmat(thisPoint, length(cellsVertices), 1);
        distFromPoint = (cellsVertices - thisPointMat) .^ 2;
        distFromPoint = sum(distFromPoint, 2);
        distFromPoint = sqrt(distFromPoint);
        [~, idx] = max(distFromPoint);
        firstPole = cellsVertices(idx,:);
        firstPoleIdx = thisCell(idx);
        firstPoleMat = repmat(firstPole, length(cellsVertices), 1);
        firstRad = distFromPoint(idx);
        
        %find the second pole
        vectorToFurthestMat = firstPoleMat - thisPointMat;
        vectorToEach = cellsVertices - thisPointMat;
        negativeDot = dot(vectorToFurthestMat, vectorToEach, 2) < 0;
        onlyNegatives = distFromPoint(negativeDot, :);
        [secondRad, idx] = max(onlyNegatives);
        filteredVertices = thisCell(negativeDot);
        secondPoleIdx = filteredVertices(idx);
        
        addedFirst = false;
        
        if(isempty(find(polesMat == firstPoleIdx)))
            %if the first pole wasn't created yet, add it to the list
            polesMat(j) = firstPoleIdx;
            poleRadMat(j) = firstRad;
            sampleIdxForPole(j) = i;
            secondOppIdx = j;
            firstj = j;
            j=j+1;
            addedFirst = true;
        else
            secondOppIdx = find(polesMat == firstPoleIdx);
        end
        if(isempty(find(polesMat == secondPoleIdx)))
            %if the second pole wasn't created yet, add it to the list
            polesMat(j) = secondPoleIdx;
            poleRadMat(j) = secondRad;
            sampleIdxForPole(j) = i;
            firstOppIdx = j;
            oppositePoleIdx(j) = secondOppIdx;
            j=j+1;
        else
            firstOppIdx = find(polesMat == secondPoleIdx); 
        end
        
        %if the first pole was added, set it's opposite pole
        if(addedFirst)
            oppositePoleIdx(firstj) = firstOppIdx;
        end

    end
    %remove left over entries from the lists
    polesMat(polesMat==-1) = [];
    poleRadMat(poleRadMat==-1) = [];
    sampleIdxForPole(sampleIdxForPole==-1) = [];
    oppositePoleIdx(oppositePoleIdx==-1) = [];
    
    %create the list of pole points, instead of just indices into the point list
    poleVerts = verts(polesMat, :);
end


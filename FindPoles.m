function [ outerPoleMat, innerPoleMat ] = FindPoles( verts, cells, points )
    outerPoleMat = zeros(length(cells), 3);
    innerPoleMat = zeros(length(cells), 3);
    for i =1:length(cells)
        thisPoint = points(i,:);
        thisCell = cells{i};
        cellsVertices = verts(thisCell,:); 
        
        %find the furthest voroni vertex
        thisPointMat =  repmat(thisPoint, length(cellsVertices), 1);
        distFromPoint = abs(cellsVertices - thisPointMat);
        distFromPoint = sum(distFromPoint, 2);
        [~, idx] = max(distFromPoint);
        firstPole = cellsVertices(idx,:);
        firstPoleMat = repmat(firstPole, length(cellsVertices), 1);
        
        %find the second pole
        vectorToFurthestMat = firstPoleMat - thisPointMat;
        vectorToEach = cellsVertices - thisPointMat;
        negativeDot = dot(vectorToFurthestMat, vectorToEach, 2) < 0;
        onlyNegatives = distFromPoint(negativeDot, :);
        filteredVertices = cellsVertices(negativeDot, :);
        [~, idx] = max(onlyNegatives);
        secondPole = filteredVertices(idx,:);
        outerPoleMat(i, :) = firstPole;
        innerPoleMat(i, :) = secondPole;
        %hold on;
        %plot cell hull
        %hull = convhulln(cellsVertices); 
        %patch('Vertices',cellsVertices,'Faces',hull,'FaceColor','g','FaceAlpha',0.2) 
        %plot this vertex
        %plot3(thisPoint(1), thisPoint(2), thisPoint(3),  'ws--', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
        %plot poles
        %plot3(firstPole(1), firstPole(2), firstPole(3),  'ws--', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
        %plot3(secondPole(1), secondPole(2), secondPole(3),  'ws--', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
    end

end


function [ poleVerts, poleRadMat, sampleIdxForPole, oppositePoleIdx] = FindPoles( verts, cells, points )
    polesMat = ones(length(cells)*2, 1) *-1;
    poleRadMat = ones(length(cells)*2, 1) *-1;
    sampleIdxForPole = ones(length(cells)*2,1) *-1;
    oppositePoleIdx = ones(length(cells)*2,1) *-1;
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
        
        %update the opposite indices for the ones added
        if(addedFirst)
            oppositePoleIdx(firstj) = firstOppIdx;
        end

    end
    polesMat(polesMat==-1) = [];
    poleRadMat(poleRadMat==-1) = [];
    sampleIdxForPole(sampleIdxForPole==-1) = [];
    oppositePoleIdx(oppositePoleIdx==-1) = [];
    
    poleVerts = verts(polesMat, :);
end


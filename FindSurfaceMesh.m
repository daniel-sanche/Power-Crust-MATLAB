function [meshVerts, meshEdges] = FindSurfaceMesh( labels, edgeList, vertsForCells, polePts, poleRads)

%find the lists of all vertices touching the inside, and all vertices
%touching the outside
insideVerts = [];
outsideVerts = [];
for i=1:length(labels)
   verts = vertsForCells{i};
   [numVerts,~] = size(verts);
   label = labels(i);
   if (label==0)
       [currentIdx,~] = size(outsideVerts);
       outsideVerts(currentIdx+1:currentIdx+numVerts,:) = verts;
   else
       [currentIdx,~] = size(insideVerts);
       insideVerts(currentIdx+1:currentIdx+numVerts,:) = verts;
   end
end

%find the listr of vertices that are on the border between the inside and
%outside
meshVerts = intersect(insideVerts, outsideVerts, 'rows');
meshVerts = unique(meshVerts, 'rows');

%find the set of edges between border vertices
meshEdges = cell(length(meshVerts),1);
edgeMidPts = zeros(length(meshVerts),2);
idx = 1;
for i=1:length(edgeList)
    points = edgeList{i};

    pt1 = points(1,:);
    pt2 = points(2,:);
    
    onBorder1 = sum(meshVerts(:, 1) == pt1(1) & meshVerts(:, 2) == pt1(2));
    onBorder2 = sum(meshVerts(:, 1) == pt2(1) & meshVerts(:, 2) == pt2(2));
    if(onBorder1 == 1 && onBorder2 == 1)
       midpt = (pt1 + pt2)./2;        
       meshEdges(idx, 1) = {points};
       edgeMidPts(idx, :) = midpt;
       idx = idx+1;
    end
end

%filter out the edges that intersect a lot with a polar ball
intersectsBall = zeros(length(edgeMidPts),1);

for i=1:length(edgeMidPts)
   midPt = edgeMidPts(i,:);
   midPtMat = repmat(midPt, length(polePts), 1);
   distanceMat = midPtMat - polePts;
   distanceMat = distanceMat .^ 2;
   distanceMat = sum(distanceMat,2);
   distanceMat = sqrt(distanceMat);
   distanceMat = distanceMat - poleRads;
   
   if(min(distanceMat)<-0.01)
      intersectsBall(i) = 1;
   end
end
meshEdges = meshEdges(~intersectsBall);
end

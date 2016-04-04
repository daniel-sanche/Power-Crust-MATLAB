function [meshVerts, meshEdges] = FindSurfaceMesh( labels, edgeList, vertsForCells, polePts, poleRads, boundingBox)
  % generates the surface mesh for the model
  %
  % inputs:
  % labels - a vector representing the label of each pole (1=inside,0=outside)
  % edgeList - a list of power cells from the power diagram of the poles
  %            each cell contains a list of edges between vertices
  % vertsForCells - a list of the vertices associated with each cell of the power diagram
  % polePts -  a list of the vertices of the poles. Each row represents a distinct point, and the 
  %            columns represent the coordinate values
  % poleRads - a list of the radius for each pole. Represents the distance from the pole
  %            to its nearest point in the point cloud
  % boundingBox - a list of points representing the box around the input
  %               point cloud
  %
  % outputs:
  % meshVerts - a list of all the vertices on the output surface mesh
  % meshEdges - a list of edges between the meshVerts, creating a solid polygonal mesh
  %             represented by a cell array, where each cell contains two vertices that can be joined with a line


  %% find the lists of all vertices touching the inside, and all vertices touching the outside
  insideVerts = [];
  outsideVerts = [];
  %iterate through each cell, adding all vertices to the inside and outside lists
  for i=1:length(labels)
    verts = vertsForCells{i};
    [numVerts,~] = size(verts);
    label = labels(i);
    if (label==0)
      %add all vertices to the outside list
      [currentIdx,~] = size(outsideVerts);
      outsideVerts(currentIdx+1:currentIdx+numVerts,:) = verts;
    else
      %add all vertices to the inside list
      [currentIdx,~] = size(insideVerts);
      insideVerts(currentIdx+1:currentIdx+numVerts,:) = verts;
    end
  end

  %% find the list of vertices that are on both the inside and outside
  meshVerts = intersect(insideVerts, outsideVerts, 'rows');
  meshVerts = unique(meshVerts, 'rows');
  
  %toss any vertices that are outside of the bounding box
  inBox = IsInBoundingBox(meshVerts, boundingBox);
  meshVerts(~inBox,:) = [];

  %% find the set of edges between border vertices
  [~, dim] = size(meshVerts);
  meshEdges = cell(length(meshVerts),1);
  edgeMidPts = zeros(length(meshVerts),dim);
  idx = 1;
  %iterate through every edge in the power diagram
  for i=1:length(edgeList)
    points = edgeList{i};
    %find the vertices involved in the edge
    pt1 = points(1,:);
    pt2 = points(2,:);
    onBorder1 = ismember(pt1, meshVerts, 'rows');
    onBorder2 = ismember(pt2,meshVerts,'rows');
    %if both vertices are on the border of the inside and the outside, keep the edge
    if(onBorder1 && onBorder2)
      midpt = (pt1 + pt2)./2;        
      meshEdges(idx, 1) = {points};
      edgeMidPts(idx, :) = midpt;
      idx = idx+1;
    end
  end

  %% filter out the edges that intersect significantly with a polar ball
  intersectsBall = zeros(length(edgeMidPts),1);
  significantVal = 0.02;

  for i=1:length(edgeMidPts)
    %find the distance between the mid point of the edge, and all polar balls
    midPt = edgeMidPts(i,:);
    midPtMat = repmat(midPt, length(polePts), 1);
    distanceMat = midPtMat - polePts;
    distanceMat = distanceMat .^ 2;
    distanceMat = sum(distanceMat,2);
    distanceMat = sqrt(distanceMat);
    distanceMat = distanceMat - poleRads; 
    %if they overlap significantly, mark it as overlapping
    if(min(distanceMat)<-significantVal)
      intersectsBall(i) = 1;
    end
  end
  %remove all overlapping values from the list of edges
  meshEdges = meshEdges(~intersectsBall);
end

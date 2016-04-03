function [PC, powers] = powercentersPD(T, E, wts)
% function [PC, powers] = powercentersPD(T, E, wts)
%
% T: triangulation
% E: set of points
% wts: weights of points in E
%
% The output array PC contains the power centers of the triangles in T.
% That is, row i of PC contains the point that is equidistant from each
% vertex of the triangle specified by row i of T, with respect to the power
% of each vertex. The output array powers contains the power of each power
% center.

[m, n] = size(T);
PC = zeros(m,n-1);
powers = zeros(m,1);

%figure;
%hold on;
for i=1:m
    triangle = E(T(i,:),:);
    weight = wts(T(i,:));
    firstPoint = triangle(1,:);
    firstPointMat = repmat(firstPoint, n-1, 1);
    otherTwo = triangle(2:n,:);
    diffFromFirst = 2*(otherTwo - firstPointMat);
    
    pointWeightMat = repmat(weight(1), n-1, 1);
    otherWeights = weight(2:n);
    firstSquared = repmat(sum(firstPoint.^2), n-1, 1);
    otherSquared = sum(otherTwo.^2, 2);
    Bc = pointWeightMat - otherWeights - firstSquared + otherSquared;
    
    pc = diffFromFirst \ Bc;
    
    PC(i,:) = pc;
    powers(i,1) = norm(pc - firstPoint')^2 - weight(1);
    
   % plot(triangle(:,1), triangle(:,2), 'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
   % plot(pc(1), pc(2), 'Marker','.','MarkerEdgeColor','b','MarkerSize',10, 'LineStyle', 'none');
end
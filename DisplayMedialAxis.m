function DisplayMedialAxis( MedialAxis, MAT )
% Takes in a medial axis and MAT, and displays it in a figure window
%
% inputs:
% MedialAxis - the collection of points representing the medial axis
% MAT - the medial axis transform. Represented by a cell array, where each
%       cell is a set of two points, representing an edge between medial axis
%       points

figure;
hold on;
for i=1:length(MAT)
   edge = MAT{i};
   plot(edge(:,1), edge(:,2), 'color','b');
end

plot(MedialAxis(:,1), MedialAxis(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',5, 'LineStyle', 'none');

hold off;

end


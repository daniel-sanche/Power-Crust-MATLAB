function DisplayMedialAxis( MedialAxis, MAT )
% Takes in a medial axis and MAT, and displays it in a figure window
%
% inputs:
% MedialAxis - the collection of points representing the medial axis
% MAT - the medial axis transform. Represented by a cell array, where each
%       cell is a set of two points, representing an edge between medial axis
%       points

[~,dim] = size(MedialAxis);

figure;
hold on;
for i=1:length(MAT)
   edge = MAT{i};
   if(dim==2)
       plot(edge(:,1), edge(:,2), 'color','b');
   elseif (dim==3)
       plot3(edge(:,1), edge(:,2), edge(:,3), 'color','b');
   end
end

if(dim==2)
   plot(MedialAxis(:,1), MedialAxis(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',5, 'LineStyle', 'none');
elseif (dim==3)
   plot3(MedialAxis(:,1), MedialAxis(:,2), MedialAxis(:,3),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
end
title('Medial Axis Transform');
hold off;

end


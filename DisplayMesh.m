function DisplayMesh( meshEdges )
% Takes in a mesh, and displays it in a figure window
%
% inputs:
% meshEdges - a cell array, where each cell holds two points that represent
% an edge on the surface mesh


[numEdges, ~] = size(meshEdges);

figure;
hold on;
for i=1:numEdges
   pts = meshEdges{i}; 
   [~,dim] = size(pts);
   if(dim==2)
    plot(pts(:,1),pts(:,2), 'color', 'r');
   elseif (dim==3)
    plot3(pts(:,1),pts(:,2),pts(:,3), 'color', 'r');
   end
end
title('Surface Mesh');
hold off;

end


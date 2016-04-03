function DisplayMesh( meshEdges )

[numEdges, ~] = size(meshEdges);

figure;
hold on;
for i=1:numEdges
   pts = meshEdges{i}; 
   plot(pts(:,1),pts(:,2));
end
hold off;

end


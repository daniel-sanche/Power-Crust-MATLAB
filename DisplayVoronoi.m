function DisplayVoronoi( cells, verts, points )
figure;
hold on;
plot(points(:,1),points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none') 
for i = 1:length(cells)
    if all(cells{i}~=1)  
        patch(verts(cells{i},1),verts(cells{i},2),i);
    end
end
hold off;

end


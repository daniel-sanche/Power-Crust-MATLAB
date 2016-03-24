function DisplayVoronoi3D(V, C, X)
    figure('Color','w') 
    for k=length(C):-1:1
        clf
         plot3(X(:,1),X(:,2),X(:,3),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none') 
        if all(C{k}~=1) 
           VertCell = V(C{k},:); 
           KVert = convhulln(VertCell); 
           patch('Vertices',VertCell,'Faces',KVert,'FaceColor','g','FaceAlpha',0.5); 
           pause(0.001)
        end 
    end
end
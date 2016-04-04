function DisplayMedialAxis( MedialAxis, MAT )

figure;
hold on;
for i=1:length(MAT)
   edge = MAT{i};
   plot(edge(:,1), edge(:,2), 'color','b');
end

plot(MedialAxis(:,1), MedialAxis(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',5, 'LineStyle', 'none');

hold off;

end


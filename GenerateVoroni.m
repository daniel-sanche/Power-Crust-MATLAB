function [vertices, cells] = GenerateVoroni( x, y, z )
    x = double(x);
    y = double(y);
    z = double(z);
    plot3(x,y,z,'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none') 
    X=[x y z]; 
    [vertices,cells]=voronoin(X); 
end


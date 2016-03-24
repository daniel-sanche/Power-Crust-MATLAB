function [points] = GenerageCircle(Radius, Spacing)

points = [];
i=1;
for x=-Radius:Spacing:Radius
    ysquared = -(x^2) + Radius^2;
    y = sqrt(ysquared);
    points(i,:) = [x y];
    points(i+1,:) = [x -y];
    i=i+2;
end
for y=-Radius:Spacing:Radius
    xsquared = -(y^2) + Radius^2;
    x = sqrt(xsquared);
    points(i,:) = [x y];
    points(i+1,:) = [-x y];
    i=i+2;
end
%plot(points(:,1), points(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none')

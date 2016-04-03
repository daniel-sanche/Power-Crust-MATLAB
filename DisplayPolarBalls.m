function DisplayPolarBalls( poles, radii )
figure;
hold on;
plot(poles(:,1),poles(:,2),'Marker','.','MarkerEdgeColor','b','MarkerSize',10, 'LineStyle', 'none') 
for i = 1:length(radii)
    x = poles(i,1);
    y = poles(i,2);
    r = radii(i);
    circle(x,y,r);
end
hold off;

end

function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp);
end
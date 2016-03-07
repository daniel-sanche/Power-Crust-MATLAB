ptCloud = pcread('teapot.ply');

x = gallery('uniformdata',[1 10],0);
y = gallery('uniformdata',[1 10],1);
 

[vx, vy] = GenerateVoroni(x, y);
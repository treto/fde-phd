clear,clc,close all
syms s w t

% x_min = -10;
% x_max = 10;
% y_min = -10;
% y_max = 10;

x = 0:0.1:5;
y = 0:0.1:5;
% plot(x, y);
tri = delaunay(x, y);
% trisurf(tri, x, y);

% 
% load seamount
% tri = delaunay(x,y);
% trisurf(tri,x,y,z);
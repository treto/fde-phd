close all
% range = [-1.1 1.1];
% 
% x = 0:0.05:2*pi;
% plot(sin(x), cos(x));
% xlim(range)
% ylim(range)
% 
% hold on

points = [0 0; 5 1];
% sqrt(sum((points(1,:) - points(2,:).^ 2)));
new_vertice = [(edge_start(1, 1)+edge_end(1,1))/2 (edge_start(1, 2)+edge_end(1,2))/2];
% sqrt(sum(((points(1,:) - points(2,:)).^ 2)))
% a_point = points(1,:);
% b_point = points(2,:);
% sqrt((a_point(1) - b_point(1))^2 + (a_point(2) - b_point(2))^2)
sqrt(sum(((points(1,:) - points(2,:)).^ 2)))
% sqrt((diff(points).^ 2)
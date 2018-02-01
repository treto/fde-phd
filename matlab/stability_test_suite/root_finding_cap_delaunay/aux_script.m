% V = [sin(0:0.5:2*pi)' cos(0:0.5:2*pi)'];
close all
clear all
number_of_steps = 8;
step = (2*pi)/number_of_steps;

V = [sin(0:step:2*pi)' cos(0:step:2*pi)'];
mid_point = (V(1,:) + V(2,:))/2
distance = sqrt(mid_point(1)^2 + mid_point(2)^2)
multiplier = 1/distance;
plot(V(:,1), V(:,2))
hold on
plot(multiplier*V(:,1), multiplier*V(:,2))
plot(sin(0:0.0001:2*pi), cos(0:0.0001:2*pi));


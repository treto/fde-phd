close all
range = [-1.1 1.1];

x = 0:0.01:2*pi;
plot(sin(x), cos(x));
xlim(range)
ylim(range)

hold on

V = 
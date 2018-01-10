close all
clc
clear all

x = -1:0.06:1;

circle_input = x + x'*1i;
% circle_input = circle_input(abs(circle_input < 1));
f = abs(arrayfun(@sample_eval_func, x + x'*1i));
% for x_inp=x
%     for y_inp=y
%         f = sample_eval_func(x + x*1i);
%     end
% end
% 
% mgrid = meshgrid(x,x);
surf(x, x, f);

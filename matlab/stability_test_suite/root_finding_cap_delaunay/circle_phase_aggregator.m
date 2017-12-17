clear,clc,close all
syms s w t
delta_r = 0.1;
phase_diff = eps;

% todo: improve precision in matlab, use good libs/compiler

z = tf('z');
Gz = (z-1)/(z-2);

input = 2;
evalfr(Gz,input)
% eval_func(Gzer, Gpol, input);

x_circ = real(input);
y_circ = imag(input);

x = 0:0.1:2*pi;
plot(cos(x)*delta_r + x_circ, sin(x)*delta_r + y_circ)
hold on
k_point_count = 100;
fun_values = zeros(k_point_count, 1);
arg_values = zeros(k_point_count, 1);
for point_id=1:k_point_count
    x_point = delta_r*cos(2*pi*point_id/k_point_count) + x_circ;
    y_point = delta_r*sin(2*pi*point_id/k_point_count) + y_circ;
    fun_values(point_id) = evalfr(Gz, x_point + y_point*1j);
    scatter(x_point, y_point, 'rx');
end
% %% old arg computations
% arg_values = angle(fun_values);
% % arg_values = unwrap(arg_values);
% % for id=1:numel(arg_values)
% %      if(arg_values(id) < 0)
% %          arg_values(id) = arg_values(id) + 2*pi;
% %      end
% % end
% arg_diff = zeros(numel(arg_values), 1);
% for arg_id = 1:(numel(arg_values)-1)
%     arg_diff(arg_id) = arg_values(arg_id+1) - arg_values(arg_id);
% end
% % arg_diff(numel(arg_values)) = arg_diff(numel(1)) - arg_values(1);
% arg_values(numel(arg_values));
% % arg_diff(numel(arg_values)) = 2*pi + arg_values(1) - arg_values(numel(arg_values));
% % arg_diff(numel(arg_values)) = arg_values(1) - arg_values(numel(arg_values));
% for arg_id = 1:numel(arg_values)
%     if(arg_diff(arg_id) > pi)
%         arg_diff(arg_id) = 0
%     end
% end
% % arg_diff = (arg_values - circshift(arg_values, 1))/(2*pi);
% % to dwa pi jest potrzebne, ten skok to informacja ze jest biegun
% % 
%% New argument computations
arg_diff = zeros(numel(fun_values), 1);
for arg_id = 1:(numel(fun_values)-1)
    arg_diff(arg_id) = angle(fun_values(arg_id+1)/fun_values(arg_id));
end
arg_diff(numel(fun_values)) = angle(fun_values(1)/fun_values(numel(fun_values)));
sum_angle = sum(arg_diff)/(2*pi);
sum_angle

% scatter(real(input),imag(input), 'rx')
% hold on
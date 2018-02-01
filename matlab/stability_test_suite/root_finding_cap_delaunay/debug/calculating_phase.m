close all;
clear all;
clc


a =[0.3095   -0.0798;
    0.4992    0.0426;
    0.7299   -0.1381];

delta_r = 0.001;
output = zeros(3, 1);

zero = [0.5 0];
vert = zero + 0.5*(rand(3,2) - 0.5);
vert = a;

%% Argument computations using division
arg_diff = [angle(output(2)/output(1)) angle(output(3)/output(2)) angle(output(1)/output(3))];
sum_angle = sum(arg_diff)/(2*pi);
phase_change = sum_angle;
%     if(phase_change == 1)
%         sum(arg_diff)
%         output
%     end

% combntns(1:3, 2)

% a1 = (vert(1,2) - vert(2,2))/(vert(1,1) - vert(2,1));
% b1 = vert(1,2) - a1*vert(1,1);


% TODO: must go clockwise (q1 to q2 and so on, so that SIGN is correct)
x = 0:delta_r:1;
edge_points = [];
diff_v = vert(2,:) - vert(1,:);
edge_points = [edge_points; [(vert(1,1) + diff_v(1)*x)'  (vert(1,2) + diff_v(2)*x)']];
diff_v = vert(3,:) - vert(2,:);
edge_points = [edge_points; [(vert(2,1) + diff_v(1)*x)'  (vert(2,2) + diff_v(2)*x)']];
diff_v = vert(1,:) - vert(3,:);
edge_points = [edge_points; [(vert(3,1) + diff_v(1)*x)'  (vert(3,2) + diff_v(2)*x)']];
ang_sum = 0;
last_point_id = (numel(edge_points)/2); 

if(angle(sample_eval_func(complex(edge_points(2, 1), edge_points(2,2)))/sample_eval_func(complex(edge_points(1, 1), edge_points(1,2)))) > 0)
    sign = 1;
else 
    sign = -1;
end

for point_id=2:last_point_id
    ang_sum = ang_sum + angle(sample_eval_func(complex(edge_points(point_id, 1), edge_points(point_id,2)))/sample_eval_func(complex(edge_points(point_id-1, 1), edge_points(point_id-1,2))));
end
ang_sum = ang_sum + angle(sample_eval_func(complex(edge_points(1, 1), edge_points(1,2)))/sample_eval_func(complex(edge_points(last_point_id, 1), edge_points(last_point_id,2))))
ang_sum
ang_sum/(2*pi)
actual = ang_sum*sign/(2*pi)

subplot(121)
plot(edge_points(:, 1), edge_points(:, 2));
hold on
x = 0:0.001:2*pi;
plot(sin(x), cos(x));

scatter(vert(:,1), vert(:, 2), 'rx');
scatter(zero(:,1), zero(:, 2), 'bo');
% xlim([0.4 0.6])
% ylim([0.4 0.6])
xlim([-1.1 1.1])
ylim([-1.1 1.1])

x = -1:0.01:1;
f_abs = abs(arrayfun(@sample_eval_func, x + x'*1i));
f_ang = angle(arrayfun(@sample_eval_func, x + x'*1i));
% subplot(row_count, col_count, 2)
% h = surf(x, x, f_abs);
% set(h,'LineStyle','none')
% title('Function absolute value')
% xlim([-plot_lim plot_lim])
% ylim([-plot_lim plot_lim])
% colorbar

subplot(122)
h = surf(x, x, f_ang);
set(h,'LineStyle','none')
title('Function argument value')
xlim([-1.1 1.1])
ylim([-1.1 1.1])
colorbar
% hold on
% triplot(tri, V(:, 1), V(:, 2), 'color', 'k');

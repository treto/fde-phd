function phase_change = caclculate_phase_change_for_triangle_given_fun_integral(input_function, triangle_vertices, precision)
delta_r = precision;
vert = triangle_vertices;
%% Argument computations using division
x = 0:delta_r:1;
diff_v = vert(2,:) - vert(1,:);
edge_points = [];
edge_points = [edge_points; [(vert(1,1) + diff_v(1)*x)'  (vert(1,2) + diff_v(2)*x)']];
diff_v = vert(3,:) - vert(2,:);
edge_points = [edge_points; [(vert(2,1) + diff_v(1)*x)'  (vert(2,2) + diff_v(2)*x)']];
diff_v = vert(1,:) - vert(3,:);
edge_points = [edge_points; [(vert(3,1) + diff_v(1)*x)'  (vert(3,2) + diff_v(2)*x)']];
ang_sum = 0;

% Ensure that clockwise direction is used, if not - then just change sign
first_phase_diff = angle(sample_eval_func(complex(edge_points(2, 1), edge_points(2,2)))/sample_eval_func(complex(edge_points(1, 1), edge_points(1,2))));
if((first_phase_diff > 0) || (first_phase_diff > -pi))
    sign = 1;
else 
    sign = -1;
end

last_point_id = (numel(edge_points)/2); 
for point_id=2:last_point_id
%     global H;
%     complex(edge_points(point_id, 1), edge_points(point_id,2));
%     evalfr(H, complex(edge_points(point_id, 1), edge_points(point_id,2)));
%     input_function(complex(edge_points(point_id, 1), edge_points(point_id,2)));
%     angle(input_function(complex(edge_points(point_id, 1), edge_points(point_id,2))));
    ang_sum = ang_sum + angle(input_function(complex(edge_points(point_id, 1), edge_points(point_id,2)))/input_function(complex(edge_points(point_id-1, 1), edge_points(point_id-1,2))));
end
ang_sum = ang_sum + angle(input_function(complex(edge_points(1, 1), edge_points(1,2)))/input_function(complex(edge_points(last_point_id, 1), edge_points(last_point_id,2))));
phase_change = (sign*ang_sum)/(2*pi);

return
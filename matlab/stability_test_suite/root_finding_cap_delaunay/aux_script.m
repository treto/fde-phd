input_function = @sample_eval_func;

dist_per = 0:0.1:1;

triangle_vertices = [0 0; 1 1; 1 2];

vert = triangle_vertices;

dist_a_b = sqrt(sum((vert(1, :) - vert(2, :)).^2))
dist_b_c = sqrt(sum((vert(2, :) - vert(3, :)).^2))
dist_c_a = sqrt(sum((vert(3, :) - vert(1, :)).^2))

edge_points = 




%% Argument computations using division
x = 0:delta_r:1;
diff_v = vert(2,:) - vert(1,:);

% @brief: Calculates total phase change on a triangle
% 
% @param Gz                 discrete complex function that is evaluated
% @param triangle_vertices  three triangle vertices
%
% @retval integer value with total phase change for a triangle
function phase_change = calculate_phase_change_for_triangle(Gz, triangle_vertices, precision)
    delta_r = precision;
    % TODO: improve precision in matlab, use good libs/compiler
    output = zeros(3, 1);
    for vert_id=1:3
        output(vert_id) = evalfr(Gz, triangle_vertices(vert_id)); 
    end
    %% Argument computations using division
    arg_diff = [angle(output(2)/output(1)) angle(output(3)/output(2)) angle(output(1)/output(3))];
    sum_angle = sum(arg_diff)/(2*pi);
    phase_change = sum_angle;
    if(phase_change == 1)
        sum(arg_diff)
        output
    end
end
% @brief: Calculates total phase change on a circle drawn on input point
% 
% @param Gz         discrete complex function that is evaluated
% @param input      complex input point
%
% @retval integer value with total phase change
function phase_change = calculate_phase_change(Gz, input, precision)
    delta_r = precision;
    % TODO: improve precision in matlab, use good libs/compiler
    evalfr(Gz,input);
    x_circ = real(input);
    y_circ = imag(input);
    k_point_count = 24;
    %% Computing complex function values on the circle
    fun_values = zeros(k_point_count, 1);
    for point_id=1:k_point_count
        x_point = delta_r*cos(2*pi*point_id/k_point_count) + x_circ;
        y_point = delta_r*sin(2*pi*point_id/k_point_count) + y_circ;
        fun_values(point_id) = evalfr(Gz, x_point + y_point*1j);
    end
    %% Argument computations using division
    arg_diff = zeros(numel(fun_values), 1);
    for arg_id = 1:(numel(fun_values)-1)
        arg_diff(arg_id) = angle(fun_values(arg_id+1)/fun_values(arg_id));
    end
    arg_diff(numel(fun_values)) = angle(fun_values(1)/fun_values(numel(fun_values)));
    sum_angle = sum(arg_diff)/(2*pi);
    phase_change = sum_angle;
end
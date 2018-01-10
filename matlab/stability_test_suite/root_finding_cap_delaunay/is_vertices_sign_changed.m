% @brief: Checks if a sign change in realis or imaginaris parts of the two
% complex values has occured
% 
% @param input_x complex value
% @param input_y complex value
%
% @retval boolean value, true if sign changed, false otherwise
function is_sign_changed = is_vertices_sign_changed(input_x, input_y)
% TODO: major factor of the algorithm is whether we use OR or AND here. OR
% indicates a phase change of +-PI/2 or more, while AND is +-PI. The latter
% converges much faster, but it is not verified whether it can locate all
% zeros.
    is_sign_changed = (sign(real(input_x)) ~= sign(real(input_y))) && ...
        ((sign(imag(input_x)) ~= sign(imag(input_y))));
end
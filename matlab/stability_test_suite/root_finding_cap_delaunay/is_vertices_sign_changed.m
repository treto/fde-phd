% @brief: Checks if a sign change in realis or imaginaris parts of the two
% complex values has occured
% 
% @param input_x complex value
% @param input_y complex value
%
% @retval boolean value, true if sign changed, false otherwise
function is_sign_changed = is_vertices_sign_changed(input_x, input_y)
    is_sign_changed = (sign(real(input_x)) ~= sign(real(input_y))) && ...
        ((sign(imag(input_x)) ~= sign(imag(input_y))));
end
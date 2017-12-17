% @brief: Verifies stability of a discrete-time, integer-order system by checking i
% eigenvalues of the characteristic polynomial all lay inside the complex
% unit circle
% 
% @param transfer_fun TransferFunction objject
%
% @retval boolean value, true if system is stable, false otherwise
function point = eval_func(Gz, Gp, input)
    output = 1;
    for i=1:numel(Gz)
        output = output*(input - Gz(i));
    end

    for i=1:numel(Gp)
        output = output/(input - Gp(i));
    end
    point = output;
end
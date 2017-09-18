% @brief: Verifies stability of a discrete-time, integer-order system by checking i
% eigenvalues of the characteristic polynomial all lay inside the complex
% unit circle
% 
% @param transfer_fun TransferFunction objject
%
% @retval boolean value, true if system is stable, false otherwise
function is_stable = stab_dtime_integer_asym(transfer_fun)
    is_stable = true;
    [z, p, k] = zpkdata(transfer_fun);
    poles = p{1, 1};
    poles = abs(poles);
    unstable_poles = find(poles >= 1);
    if(unstable_poles)
        is_stable = false;
    end
end
% @brief: Calculates the value of characteristic equation given as list of
% zeros for given input
% 
% @param Gz list of zeros of the characteristic equation
% @param input complex value as the input to char equation to evaluate
%
% @retval char equation value at input
function point = eval_func(Gz, input)
    output = 1;
    for i=1:numel(Gz)
        output = output*(input - Gz(i));
    end
    point = output;
end
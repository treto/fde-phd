% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = sample_eval_func(input)
    Gz = [0.1165    0.7791    0.6549    0.2300    0.4652];
    output = 1;
    for i=1:numel(Gz)
        output = output*(input - Gz(i));
    end
    point = output;
end
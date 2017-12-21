% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = sample_eval_func(input)
    output = 1;
%     just some random zeros outside unit circle
    output = output*(input - 0.5)*(input-3);
    point = output;
end
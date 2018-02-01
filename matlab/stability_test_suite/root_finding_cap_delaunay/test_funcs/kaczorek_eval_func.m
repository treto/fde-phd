% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = kaczorek_eval_func(input)

%    point = input.^4 + 1.1*input.^3 - 0.8*input.^2 + 0.1*input - 0.9;
point = -0.9*input.^4 + 0.1*input.^3 - 0.8*input.^2 + 1.1*input + 1;
end
% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = sample_eval_func(input)
%     Gz = [0.1    0.75    0.65    0.25    0.45 0.5 + 0.5i 0.5 - 0.5i -0.4 -0.3];
%     Gz = [0.1    0.75    0.65    0.25    0.45];
    Gz = [0.5   0.25+0.5i 0.25-0.5i];
    output = 1;
    for i=1:numel(Gz)
        output = output*(input - Gz(i));
    end
    point = output;
end
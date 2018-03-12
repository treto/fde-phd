% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = lpc_12_eval_func(input)
    Gw = [-0.8000 + 1.6000i  -0.8000 - 1.6000i  -0.7059 + 0.8235i  -0.7059 - 0.8235i  -0.3319 + 1.1546i  -0.3319 - 1.1546i
    1.1765 + 0.2941i   1.1765 - 0.2941i   0.7671 + 0.7123i   0.7671 - 0.7123i   0.8293 + 0.5366i   0.8293 - 0.5366i];
    output = 1;
    for i=1:numel(Gw)
        output = output*(input - Gw(i));
    end
    point = output;
end
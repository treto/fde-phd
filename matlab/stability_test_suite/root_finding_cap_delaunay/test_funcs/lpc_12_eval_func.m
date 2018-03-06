% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = lpc_12_eval_func(input)
%     Gz = [0.1    0.75    0.65    0.25    0.45 0.5 + 0.5i 0.5 - 0.5i -0.4 -0.3];
%     Gz = [0.1    0.75    0.65    0.25    0.45];
%     Gz = [0.5];
%      Gz = [0.5 0.5 1.25+0.5i 1.25-0.5i];
%      Gz = [0.8 + 0.2i 0.8 - 0.2i 0.85 + 0.55i 0.85 - 0.55i 0.7 + 0.65i 0.7 - 0.65i -0.25 + 0.5i -0.25 - 0.5i 0.23 + 0.8i 0.23-0.8i -0.6+0.7i -0.6-0.7i];
     

%      Gz = [0.8 + 0.2i 0.8 - 0.2i 0.85 + 0.55i 0.85 - 0.55i 0.7 + 0.65i 0.7 - 0.65i -0.25 + 0.5i -0.25 - 0.5i 0.23 + 0.8i 0.23-0.8i -0.6+0.7i -0.6-0.7i];
%      Gw = 1/Gz;
    Gw = [1.1765 - 0.2941i   1.1765 + 0.2941i   0.8293 - 0.5366i   0.8293 + 0.5366i   0.7671 - 0.7123i   0.7671 + 0.7123i  -0.8000 - 1.6000i -0.8000 + 1.6000i   0.3319 - 1.1546i   0.3319 + 1.1546i  -0.7059 - 0.8235i  -0.7059 + 0.8235i];
%     Gz = [0.3];
    output = 1;
    for i=1:numel(Gw)
        output = output*(input - Gw(i));
    end
    point = output;
end
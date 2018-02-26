% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = high_order_eval_func(input)

    point = 1;
    global system_zeros;
    global H;
    zero_count = length(system_zeros);

%     input
    point = evalfr(H,input);


%     for zero=system_zeros
%        point = point*(input - zero);
%     end
end
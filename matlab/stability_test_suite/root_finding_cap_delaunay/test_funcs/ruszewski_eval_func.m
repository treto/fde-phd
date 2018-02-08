% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = ruszewski_eval_func(input)
    p=input;
    alpha=0.5;
    af=-1.42;%-1.5;
    w=(p^(-1))*(1-p)^alpha;
    point = w - af;
    point = point*p;
end
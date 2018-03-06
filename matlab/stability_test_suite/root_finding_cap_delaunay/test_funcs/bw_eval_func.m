% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = bw_eval_func(input)
    p=input;
    
    alpha=0.5;
    beta=0.5;
    
    a=1;
    %c=-(1.3333e+03 - 5.1640e+01i);
    c=-1000+50i;
    
    T=0.001;
    
    s=2/T*(1-p)/(1+p);
    
    point = s^(alpha+beta)+a*s^alpha+c;
    point = point*(1+p)^(alpha+beta);
end
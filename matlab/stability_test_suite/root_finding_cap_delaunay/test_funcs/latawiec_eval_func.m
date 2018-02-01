% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = latawiec_eval_func(input)
    %z=input^(-1);
    p=input;
    alpha=0.7;
    a11=0.6;
    a12=-1.45;
    a21=1;
    a22=-1;
    %w=z*(1-(z^(-1)))^alpha;
    %point = (w-a11)*(w-a22)-a21*a12;
    %point = z^2*point;
    w=(p^-1)*(1-p)^alpha;
    point = (w-a11)*(w-a22)-a21*a12; 
    point = p^2*point;
end
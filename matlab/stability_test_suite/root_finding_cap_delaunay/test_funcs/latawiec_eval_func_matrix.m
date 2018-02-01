% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = latawiec_eval_func_matrix(input)
    %z=input^(-1);
    p=input;
    alpha=0.7;
    a11=0.6;
    a12=-1.45;
    a21=1;
    a22=-1;
    A=[a11 a12; a21 a22];
    r=eig(A);
    %w=z*(1-(z^(-1)))^alpha;
    %w=(p^(-1))*(1-p)^alpha;
    w=(p^-1)*(1-p)^alpha;    
    point = (w-r(1))*(w-r(2))*(p^2);
    
end
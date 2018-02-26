% @brief: Calculates the value of a function 
% 
% @param input complex value as the input to char equation to evaluate
%
% @retval complex value
function point = ruszewski_example2(input)
    %z=input^(-1);
    p=input;
    global alpha
%     alpha=0.1843; stability region
    A = [-1 0 0.1 0;
        0 -1 -0.01 0;
        0.02 0 -0.8 -0.03;
        0.77 0.05 -0.9 -1;];
       
    w=(p^-1)*(1-p)^alpha;
    A_2 = eye(4)*w;
    A_f = A_2 - A;
    point = det(A_f);
    
     %w=z*(1-(z^(-1)))^alpha;
    %point = (w-a11)*(w-a22)-a21*a12;
    %point = z^2*point;
       
%     point = (w-a11)*(w-a22)-a21*a12; 
%     point = p^2*point;
    
    
end
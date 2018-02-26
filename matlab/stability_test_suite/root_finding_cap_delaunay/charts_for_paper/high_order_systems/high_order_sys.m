close all
clear all

%REQUIRES following settings:
% number_of_init_points = 1024;
% min_distance_r = 10e-3;
% integral_step = 10e-1;

display('running our algorithm tests');
L_ranges = [10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000];
L_ranges = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500];
% L_ranges = [10];
iter_count = 10;
system_data = [];
for L=L_ranges
    L;
    global system_zeros;
    global H;    
    system_zeros = build_characteristic_equation(L);
    H = zpk(system_zeros,[],1, -1);
    timing = 0;
    for i=1:iter_count
        tStart = tic;
        [output_is_stable, output_zeros] = check_stability_using_delaunay_inv_for_fun(@high_order_eval_func, 0, 0, 1);
%         display(['zeros count [' num2str(L) '] stability : [' num2str(output_is_stable) '] zeros: ' num2str(output_zeros)]);
        duration = toc(tStart);
        timing = timing + duration;
    end
    display(['average time for zeros [' num2str(L) '] : ' num2str(timing/iter_count)])
    system_data = [system_data; L timing/iter_count];
end

save('high_order_res', 'system_data');

function system_zeros = build_characteristic_equation(number_of_zeros)
system_zeros = [-0.5];
L = number_of_zeros;
for i=1:L
%     system_zeros = [system_zeros ((-1)^i)/(0.1 * (i/L + 1))];
    system_zeros = [system_zeros ((-1)^i)/(1 - 0.4 * (i/L + 1))];
end
end

           
% 
% running our algorithm tests
% breaking!
% Iteration count:18
% zeros count [50] stability : [0] zeros: -0.50227-0.0006511i
% average time for zeros [50] : 18.7798
% breaking!
% Iteration count:18
% zeros count [100] stability : [0] zeros: -0.50227-0.0006511i
% average time for zeros [100] : 28.9823
% breaking!
% Iteration count:17
% zeros count [150] stability : [0] zeros: -0.50227-0.0006511i
% average time for zeros [150] : 45.6513
% breaking!
% Iteration count:19
% zeros count [200] stability : [0] zeros: -0.49919-0.0013154i
% average time for zeros [200] : 77.8948
% breaking!
% Iteration count:18
% zeros count [250] stability : [0] zeros: -0.49945-0.00087543i
% average time for zeros [250] : 106.7658
% breaking!
% Iteration count:18
% zeros count [300] stability : [0] zeros: -0.50285+0.00033892i
% average time for zeros [300] : 157.2958
% breaking!
% Iteration count:17
% zeros count [350] stability : [0] zeros: -0.50285+0.00033892i
% average time for zeros [350] : 183.9027
% breaking!
% Iteration count:16
% zeros count [400] stability : [0] zeros: -0.50285+0.00033892i
% average time for zeros [400] : 203.5486
% breaking!
% Iteration count:17
% zeros count [450] stability : [0] zeros: -0.50285+0.00033892i
% average time for zeros [450] : 250.7676
% breaking!
% Iteration count:18
% zeros count [500] stability : [0] zeros: -0.50227-0.0006511i
% average time for zeros [500] : 294.7975

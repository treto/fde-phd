clear all
close all
display('running roots tests')

% L_ranges = [10, 100, 1000, 10000, 1000000];
% L_ranges = [10];
% L_ranges = [10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]%, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000];
% L_ranges = [1000, 2000, 3000, 4000, 5000]%, 6000, 7000, 8000, 9000, 10000];
% L_ranges = [6000, 7000, 8000, 9000, 10000];


L_ranges = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500];

iter_count = 50;
sys_data = [];
for L=L_ranges
    L;
    system_zeros = build_characteristic_equation(L);
    timing = 0;
    for i=1:iter_count
        tic
        roots(system_zeros);
        duration = toc;
        timing = timing + duration;
        
    end
    sys_data = [sys_data; L timing/iter_count];
    display(['average time for zeros [' num2str(L) '] : ' num2str(timing/iter_count)])
end



function system_zeros = build_characteristic_equation(number_of_zeros)
system_zeros = [2];
L = number_of_zeros;
for i=1:L
    system_zeros = [system_zeros, 0.1 * (i/L + 1)];
end
end

%%RESULTS
% average time for zeros [10] : 0.0006916
% average time for zeros [100] : 0.0065117
% average time for zeros [200] : 0.032404
% average time for zeros [300] : 0.081687
% average time for zeros [400] : 0.1567
% average time for zeros [500] : 0.25647
% average time for zeros [600] : 0.40606
% average time for zeros [700] : 0.52959
% average time for zeros [800] : 0.68948
% average time for zeros [900] : 0.84343
% average time for zeros [1000] : 1.0512
% average time for zeros [2000] : 4.6361
% average time for zeros [3000] : 15.4354
% average time for zeros [4000] : 31.4393
% average time for zeros [5000] : 56.1282
% average time for zeros [6000] : 109.6903
% average time for zeros [7000] : 163.7921
% average time for zeros [8000] : 263.9699
% average time for zeros [9000] : 352.1217
% average time for zeros [10000] : 472.232805

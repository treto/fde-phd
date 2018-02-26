close all
clear all

display('running our algorithm tests');
alfa_ranges = 0.7:0.005:1.1;
sys_data = [];
for new_af=alfa_ranges
    global alpha;
    alpha = new_af;
%     af=-1.42;%-1.5;
    
    tic
    [output_is_stable, output_zeros] = check_stability_using_delaunay_inv_for_fun(@latawiec_eval_func, 0, 0, 0);
    display(['alfa [' num2str(alpha) '] stability : [' num2str(output_is_stable) '] zeros: ' num2str(output_zeros)]);
    if isempty(output_zeros)
        output_zeros = 0;
    end
    sys_data = [sys_data; alpha output_is_stable output_zeros(1)];
    
    duration = toc;
end

save('latawiec_stability_data', 'sys_data');
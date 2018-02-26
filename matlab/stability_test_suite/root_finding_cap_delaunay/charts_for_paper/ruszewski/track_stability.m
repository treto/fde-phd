close all
clear all

display('running our algorithm tests');
alfa_ranges = -1.6:0.005:-1.2;
sys_data = [];
for new_af=alfa_ranges
    global af;
    af = new_af;
%     af=-1.42;%-1.5;
    
    tic
    [output_is_stable, output_zeros] = check_stability_using_delaunay_inv_for_fun(@ruszewski_eval_func, 0, 0, 0);
    display(['alfa [' num2str(af) '] stability : [' num2str(output_is_stable) '] zeros: ' num2str(output_zeros)]);
    if isempty(output_zeros)
        output_zeros = 0;
    end
    sys_data = [sys_data; af output_is_stable output_zeros];
    duration = toc;
end

save('ruszewski_stability_data', 'sys_data');
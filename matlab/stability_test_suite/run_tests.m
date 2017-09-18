clear,clc,close all
syms s w t

% Move this to config file in the end
k_amp = 1;
Ts = 0.01;

M = csvread('models.csv');
rows_columns_count = size(M);
nrows = rows_columns_count(1);
tic
for model_id=1:nrows/2
% Constructing model
    zeroes = M(model_id*2 - 1, :);
    poles = M(model_id*2, :);
    Gz = zpk(zeroes, poles, k_amp, 'Variable', 'z', 'Ts', Ts);    
% Stability critera 
   is_stable = stab_dtime_integer_asym(Gz);
% % Plotting 
%     subplot(211)
%     step(Gz)
%     subplot(212)
%     pzmap(Gz)
% % Saving to file
%     model_name = ['model_output', num2str(model_id)];
%     print(['output/', model_name], '-dpng')
end 
end_time = toc;
display(['Test duration: ', num2str(end_time), 's']);
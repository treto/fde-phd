close all
clc
clear all

zeros = [0.5-9.9855e-17i          0.5+4.3992e-17i          0.5+8.8544e-17i];
diff_zeros = zeros - zeros';
diff_zeros(abs(diff_zeros) < eps)

zero_id = 0;
while ~isempty(zeros) && zero_id < (numel(zeros)+1)
    
    
    
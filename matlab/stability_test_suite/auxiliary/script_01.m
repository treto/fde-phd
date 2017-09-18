clear,clc,close all
syms s w t

% transfer function
% Gz = tf([1], [0.2 0.1 0.3], 'Variable', 'z^-1', 'Ts', -1)
% step(Gz)

Gz_zeroes = [0.1, 0.3];
Gz_poles = [0.2, -0.3, 0.5i, -0.5i];

k_amp = 1;
Ts = 0.01;

Gz = zpk(Gz_zeroes, Gz_poles, k_amp, 'Variable', 'z', 'Ts', Ts);

subplot(211)
step(Gz)
subplot(212)
pzmap(Gz)
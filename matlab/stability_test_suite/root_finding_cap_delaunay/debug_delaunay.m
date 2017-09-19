%% Transfer function
k_amp = 1;
Ts = 0.1;
Gz_zeroes = [0.25 0.3];
Gz_poles = [0.1 0.2 0.5+0.1j 0.5-0.1j];
Gz = zpk(Gz_zeroes, Gz_poles, k_amp, 'Variable', 'z', 'Ts', Ts);    
%% Delaunay triangulation
x_min = -10;
x_max = 10;
init_step = 0.5;
x = x_min : init_step : x_max;
size_x = size(x);
y = 20*rand(1, size_x(2)) - 10;

%% Plotting
figure1=figure('Position', [250, 0, 1024, 1024]);
subplot(3, 2, [1 2 3 4])
tri = delaunay(x,y);
triplot(tri,x,y)
subplot(3, 2, 5)
step(Gz);
subplot(3, 2, 6)
pzmap(Gz);
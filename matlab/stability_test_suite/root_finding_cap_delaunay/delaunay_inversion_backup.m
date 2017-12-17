% How to: modify min_distance_r to change number of iterations and accuracy
% of pole/zero finding algorithm
% suggest value: 0.05

clear,clc,close all
syms s w t

%% Transfer function
k_amp = 1;
Ts = 0.1;
Gz_zeros = [0.8 0.5];
Gz_poles = [-1.5 2 (1.5+0.5j) (1.5-0.5j)];

Gz_zeros = 1./Gz_zeros
Gz_poles = 1./Gz_poles
% Gz = zpk(Gz_zeros, Gz_poles, k_amp, 'Variable', 'z', 'Ts', Ts);    
%% Delaunay triangulation
% initialize area boundaries
x_min = -2;
x_max = 2;
init_step = 0.1;
x = x_min : init_step : x_max;
size_x = size(x);
% y dim is randomized, delaunay fun cannot use collinearly dependant vars
y = 2*x_max*rand(1, size_x(2))-x_max;
V = [x' y'];
% defines minimum edge length to continue triang, i.e. defines accuracy
min_distance_r = 0.005;
iter_id = 0;
is_point_added = true;
tic;

while is_point_added == true && iter_id < 10
    display(['Iteration: ', num2str(iter_id)]);
    iter_id = iter_id + 1;
    is_point_added = false;
    point_count = numel(V)/2;
    
    % evaluate transfer function value at each vertice
    % z = jw
    % consider using "arrayfun" to speed up
    F = zeros(1, point_count);
    for point_id=1:point_count
        F(point_id) = eval_func(Gz_zeros, Gz_poles, (V(point_id, 1) + V(point_id, 2)*1i));
    end

    % each row in tri is a set of 3 points from vector of points(vertices) V
    tri = delaunay(V(:, 1), V(:, 2));

    % for each triangle, each edge
    for triangle_id = 1:numel(tri(:, 1))
        triangle_vertices = tri(triangle_id, :);
        a_f_val = F(triangle_vertices(1));
        b_f_val = F(triangle_vertices(2));
        c_f_val = F(triangle_vertices(3));

%       cant find roots, works with zeros though, update: ok roots with inf
%       in the plot, there is blank space around roots
        if(is_vertices_sign_changed(a_f_val, b_f_val))
            %display('vertices have different signs for either imag or real parts')
            a_point = [V(triangle_vertices(1), 1) V(triangle_vertices(1), 2)];
            b_point = [V(triangle_vertices(2), 1) V(triangle_vertices(2), 2)];
            if(sqrt((a_point(1) - b_point(1))^2 + (a_point(2) - b_point(2))^2)> min_distance_r)
                V = [V; [(a_point(1, 1)+b_point(1,1))/2 (a_point(1, 2)+b_point(1,2))/2]];
                is_point_added = true;
            end
        end

        if(is_vertices_sign_changed(a_f_val, c_f_val))
%             display('vertices have different signs for either imag or real parts')
            a_point = [V(triangle_vertices(1), 1) V(triangle_vertices(1), 2)];
            c_point = [V(triangle_vertices(3), 1) V(triangle_vertices(3), 2)];
            if(sqrt((a_point(1) - c_point(1))^2 + (a_point(2) - c_point(2))^2)> min_distance_r)
                V = [V; [(a_point(1, 1)+c_point(1,1))/2 (a_point(1, 2)+c_point(1,2))/2]];
                is_point_added = true;
            end
        end
        
        if(is_vertices_sign_changed(b_f_val, c_f_val))
%             display('vertices have different signs for either imag or real parts')
            b_point = [V(triangle_vertices(2), 1) V(triangle_vertices(2), 2)];
            c_point = [V(triangle_vertices(3), 1) V(triangle_vertices(3), 2)];
            if(sqrt((c_point(1) - b_point(1))^2 + (c_point(2) - b_point(2))^2)> min_distance_r)
                V = [V; [(b_point(1, 1)+c_point(1,1))/2 (b_point(1, 2)+c_point(1,2))/2]];
                is_point_added = true;
            end
        end
    end
end
duration = toc;
display(['Section time: ' num2str(duration)]);
%% Evaluation
% Finding curves C_r and C_i where real or imag part f(z) is close to 0
tic;
% Curves
eps = 2*min_distance_r;
C_r = [];
C_i = [];
C_cross = [];
for point_id=1:numel(F)
    point = [real(F(point_id)) imag(F(point_id))];
    is_real_selected = false;
    if(abs(point(1)) <= eps || 1/abs(point(1)) <= eps)
%     if(abs(V(point_id, 1)) <= eps)
        C_r = [C_r; V(point_id, :)];
        is_real_selected = true;
    end
    if(abs(point(2)) <= eps  || 1/abs(point(2)) <= eps)
%     if(abs(V(point_id, 2)) <= eps)
        C_i = [C_i; V(point_id, :)];
        if(is_real_selected == true)
            C_cross = [C_cross; V(point_id, :)];
        end
    end
end
% Zeros and poles
Gz_zeros_w = [];
Gz_poles_w = [];
for i=1:numel(Gz_zeros)
   Gz_zeros_w = [Gz_zeros_w; 0 0];
   if(real(Gz_zeros(i)) ~= 0)
       Gz_zeros_w(i, 1) = (real(Gz_zeros(i)));
   end
   if(imag(Gz_zeros(i)) ~= 0)
       Gz_zeros_w(i, 2) = (imag(Gz_zeros(i)));
   end
end

for i=1:numel(Gz_poles)
    Gz_poles_w = [Gz_poles_w; 0 0];
   if(real(Gz_poles(i)) ~= 0)
       Gz_poles_w(i, 1) = (real(Gz_poles(i)));
   end
   if(imag(Gz_poles(i)) ~= 0)
       Gz_poles_w(i, 2) = (imag(Gz_poles(i)));
   end
end
Gz_zeros_w
Gz_poles_w

duration = toc;
display(['Section time: ' num2str(duration)]);

%% Plotting
col_count = 8;
row_count = 3;
figure1=figure('Position', [10, 0, 1724, 1024]);
subplot(row_count, col_count, [1 2 9 10])
% triplot(tri,x,y)
triplot(tri, V(:, 1), V(:, 2));
title('delaunay result')
hold on

scatter(Gz_zeros_w(:, 1), Gz_zeros_w(:, 2), 'ro', 'SizeData',48);   
scatter(Gz_poles_w(:, 1), Gz_poles_w(:, 2), 'rx', 'SizeData',48);   
% scatter(real(Gz_zeros_w), imag(Gz_zeros), 'ro', 'SizeData',48);
% scatter(1/real(Gz_poles), 1/imag(Gz_poles), 'rx', 'SizeData',48);

subplot(row_count, col_count, [3 4 11 12])
scatter(C_r(:, 1), C_r(:, 2), 'g.')
title('real(f_z) curve')
xlim([-2 2])
ylim([-2 2])

subplot(row_count, col_count, [5 6 13 14])
scatter(C_i(:, 1), C_i(:, 2), 'y.')
title('imag(f_z) curve')
xlim([-2 2])
ylim([-2 2])

% the lines where f(z) is equal 0
subplot(row_count, col_count, 17)
title('step of Gz (open loop)')
% step(Gz);
subplot(row_count, col_count, 18)
title('zeros and poles of Gz')
% pzmap(Gz);
subplot(row_count, col_count, [7 8 15 16])
scatter(Gz_zeros_w(:, 1), Gz_zeros_w(:, 2), 'ro', 'SizeData',48);   
title('identified points of interest')
hold on
scatter(Gz_poles_w(:, 1), Gz_poles_w(:, 2), 'rx', 'SizeData',48);  
scatter(C_cross(:, 1), C_cross(:, 2), 'b.', 'SizeData', 48)
xlim([-2 2])
ylim([-2 2])

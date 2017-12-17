% How to: modify min_distance_r to change number of iterations and accuracy
% of pole/zero finding algorithm suggested value: 0.05
clear,clc,close all
syms s w t
%% Algorithm control flags
% Set this to true to use inversion (z = 1/w)
USE_INVERSION               = true;
USE_VERBOSE_PROFILING       = true;
%% Auxiliary variables
section_time_log = [];
%% Transfer function
k_amp = 1;
Ts = 0.1;
disp('Transfer function')
Gz_zeros = [2 0.3];
Gz_poles = [5 (0.2+0.5j) (0.2-0.5j)];
if USE_INVERSION == true
    disp('Using inversed input to the transfer function w = 1/z')
    Gz_zeros = 1./Gz_zeros;
    Gz_poles = 1./Gz_poles;
else
    display('Using input as regular z, without inversion')
end
Gz = zpk(Gz_zeros, Gz_poles, k_amp, 'Variable', 'z', 'Ts', Ts);    
%% Delaunay 
section_name = 'Section: Delaunay triangulation';
if USE_VERBOSE_PROFILING
    disp(section_name);
end
tic;
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

tri = [];
while is_point_added == true && iter_id < 10
    display(['Iteration: ', num2str(iter_id)]);
    iter_id = iter_id + 1;
    is_point_added = false;
    point_count = numel(V)/2;
    
    % evaluate transfer function value at each vertice
    % z = jw
    % consider using "arrayfun" to speed up
    tran_fun_values = zeros(1, point_count);
    for point_id=1:point_count
        tran_fun_values(point_id) = eval_func(Gz_zeros, Gz_poles, (V(point_id, 1) + V(point_id, 2)*1i));
    end

    % each row in tri is a set of 3 points from vector of points(vertices) V
    tri = delaunay(V(:, 1), V(:, 2));

    % for each triangle, each edge
    for triangle_id = 1:numel(tri(:, 1))
        triangle_vertice_ids = tri(triangle_id, :);
        a_f_val = tran_fun_values(triangle_vertice_ids(1));
        b_f_val = tran_fun_values(triangle_vertice_ids(2));
        c_f_val = tran_fun_values(triangle_vertice_ids(3));

%       cant find roots, works with zeros though, update: ok roots with inf
%       in the plot, there is blank space around roots
        if(is_vertices_sign_changed(a_f_val, b_f_val))
            %display('vertices have different signs for either imag or real parts')
            a_point = [V(triangle_vertice_ids(1), 1) V(triangle_vertice_ids(1), 2)];
            b_point = [V(triangle_vertice_ids(2), 1) V(triangle_vertice_ids(2), 2)];
            if(sqrt((a_point(1) - b_point(1))^2 + (a_point(2) - b_point(2))^2)> min_distance_r)
                V = [V; [(a_point(1, 1)+b_point(1,1))/2 (a_point(1, 2)+b_point(1,2))/2]];
                is_point_added = true;
            end
        end

        if(is_vertices_sign_changed(a_f_val, c_f_val))
%             display('vertices have different signs for either imag or real parts')
            a_point = [V(triangle_vertice_ids(1), 1) V(triangle_vertice_ids(1), 2)];
            c_point = [V(triangle_vertice_ids(3), 1) V(triangle_vertice_ids(3), 2)];
            if(sqrt((a_point(1) - c_point(1))^2 + (a_point(2) - c_point(2))^2)> min_distance_r)
                V = [V; [(a_point(1, 1)+c_point(1,1))/2 (a_point(1, 2)+c_point(1,2))/2]];
                is_point_added = true;
            end
        end
        
        if(is_vertices_sign_changed(b_f_val, c_f_val))
%             display('vertices have different signs for either imag or real parts')
            b_point = [V(triangle_vertice_ids(2), 1) V(triangle_vertice_ids(2), 2)];
            c_point = [V(triangle_vertice_ids(3), 1) V(triangle_vertice_ids(3), 2)];
            if(sqrt((c_point(1) - b_point(1))^2 + (c_point(2) - b_point(2))^2)> min_distance_r)
                V = [V; [(b_point(1, 1)+c_point(1,1))/2 (b_point(1, 2)+c_point(1,2))/2]];
                is_point_added = true;
            end
        end
    end
end

duration = toc;
section_time_log = [section_time_log [section_name duration]];
if USE_VERBOSE_PROFILING
    disp(['Section time: ' num2str(duration)]);
end
%% Evaluation
% Finding curves C_r and C_i where real or imag part f(z) is close to 0
section_name = 'Section: Curve inf/zero val evaluation';
if USE_VERBOSE_PROFILING
    disp(section_name);
end
tic;
% Curves
eps = 2*min_distance_r;
C_r = [];
C_i = [];
C_cross = [];
for point_id=1:numel(tran_fun_values)
    point = [real(tran_fun_values(point_id)) imag(tran_fun_values(point_id))];
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
Gz_zeros_w;
Gz_poles_w;

duration = toc;
section_time_log = [section_time_log [section_name duration]];
if USE_VERBOSE_PROFILING
    disp(['Section time: ' num2str(duration)]);
end
%% New root finding based on triangle phase
section_name = 'Section: Phase Change Calculation';
if USE_VERBOSE_PROFILING
    disp(section_name)
end
tic;
% Get only triangles where edge length is small, the last triangles added
% by the delaunay triangulation; roots or zeroes are inside those triangles
[triangles_near_poles, triangle_count] = get_triangles_with_edge_len_below_delta(tri, V, min_distance_r);
final_triangles = [];
pole_points = [];
singularities = [];

% For each triangle, calculate phase change based on the vertices
for triangle_id = 1:triangle_count
   triangle_vertices = triangles_near_poles(triangle_id, :);
   triangle_gravity_center = sum(V(triangle_vertices, 1))/3 + sum(V(triangle_vertices, 2))*j/3;
   if(abs(triangle_gravity_center) < 1)
%        Only searches for poles/zeros inside the unit circle
         phase_change = calculate_phase_change_for_triangle(Gz, V(triangle_vertices, :), eps);
%         phase_change = calculate_phase_change(Gz, triangle_gravity_center, eps);
       if(phase_change >= 1)
           final_triangles = [final_triangles; triangles_near_poles(triangle_id,:)];
           pole_points = [pole_points triangle_gravity_center];
       elseif(phase_change <= -1)
           singularities = [singularities triangle_gravity_center];
       end
   end
end

if USE_INVERSION == true
%  Using inversion, so need to substitute zeros and roots
%  TODO: Why is this needed?
%     display('Using inversion, replacing zeros for poles, poles for zeros')
%     poles_buffer = pole_points;
%     pole_points = zero_points;
%     singularities = poles_buffer;
end

display(['Pole candidates count: ' num2str(numel(pole_points))])
display(['Singularities candidates count: ' num2str(numel(singularities))])

duration = toc;
section_time_log = [section_time_log [section_name duration]];
if USE_VERBOSE_PROFILING
    disp(['Section time: ' num2str(duration)]);
end
%% Evaluate stability
section_name = 'Section: Evaluation';
if USE_VERBOSE_PROFILING
    disp(section_name);
end
tic;
distance_from_origin_for_poles = abs(pole_points);
if USE_INVERSION == true
    if min(distance_from_origin_for_poles) < 1
        disp('The system is unstable, one of the inverted poles lays inside the unit circle')
    else
        disp('The system is stable, none of the inverted poles lay inside the unit circle')
    end
else
    if min(distance_from_origin_for_poles > 1)
        disp('The system is stable, all regular poles are outside unit circle')
    else
        disp('The system is unstable, one of the regular poles is inside the unit circle')
    end
end

duration = toc;
section_time_log = [section_time_log [section_name duration]];
if USE_VERBOSE_PROFILING
    disp(['Section time: ' num2str(duration)]);
end
%% Plotting
section_name = 'Section: Plotting';
if USE_VERBOSE_PROFILING
    disp(section_name)
end
tic;
col_count = 8;
row_count = 3;
figure1=figure('Position', [10, 0, 1724, 1024]);
subplot(row_count, col_count, [1 2 9 10])
triplot(tri, V(:, 1), V(:, 2));
title('delaunay result')
hold on

scatter(Gz_zeros_w(:, 1), Gz_zeros_w(:, 2), 'ro', 'SizeData',48);   
scatter(Gz_poles_w(:, 1), Gz_poles_w(:, 2), 'rx', 'SizeData',48);   

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
title('identified points of interest - curve real and imag crosses')
hold on
scatter(Gz_poles_w(:, 1), Gz_poles_w(:, 2), 'rx', 'SizeData',48);  
scatter(C_cross(:, 1), C_cross(:, 2), 'b.', 'SizeData', 48)
xlim([-2 2])
ylim([-2 2])

% Draw all triangles with low edge length, these are then evaluated for
% zeros or poles using phase count
subplot(row_count, col_count, [21 22])
scatter(V(triangles_near_poles,1), V(triangles_near_poles,2), 'b.', 'SizeData', 48);
hold on
scatter(Gz_poles_w(:, 1), Gz_poles_w(:, 2), 'rx', 'SizeData',48);  
scatter(Gz_zeros_w(:, 1), Gz_zeros_w(:, 2), 'ro', 'SizeData',48);
title('triangles near poles')

% Draw poles/zeros of the transfer functions and points located using
% evaluation
subplot(row_count, col_count, [23 24])
scatter(real(singularities),imag(singularities), 'go', 'SizeData',48);  
hold on
scatter(real(pole_points),imag(pole_points), 'gx', 'SizeData',48);  
scatter(Gz_poles_w(:, 1), Gz_poles_w(:, 2), 'rx', 'SizeData',48);  
scatter(Gz_zeros_w(:, 1), Gz_zeros_w(:, 2), 'ro', 'SizeData',48);
title('final triangles')

duration = toc;
section_time_log = [section_time_log [section_name duration]];
if USE_VERBOSE_PROFILING
    disp(['Section time: ' num2str(duration)]);
end

% Gz_zeros
% Gz_poles
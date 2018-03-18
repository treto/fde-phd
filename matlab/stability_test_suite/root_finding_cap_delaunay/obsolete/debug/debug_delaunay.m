clear,clc,close all
syms s w t

%% Transfer function
k_amp = 1;
Ts = 0.1;
Gz_zeros = [0.8 0.5];
Gz_poles = [-0.5 0.2 0.5+0.5j 0.5-0.5j];
Gz = zpk(Gz_zeros, Gz_poles, k_amp, 'Variable', 'z', 'Ts', Ts);    
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
min_distance_r = 0.05
iter_id = 0;
is_point_added = true;

while is_point_added == true && iter_id < 10
    display(['Iteration: ', num2str(iter_id)]);
    iter_id = iter_id + 1;
    is_point_added = false;
    point_count = numel(V)/2;
    
    % evaluate transfer function value at each vertice
    % z = jw
    F = zeros(1, point_count);
    for point_id=1:point_count
        F(point_id) = evalfr(Gz, V(point_id, 1) + V(point_id, 2)*1i);
    end

    % each row in tri is a set of 3 points from vector of points(vertices) V
    tri = delaunay(V(:, 1), V(:, 2));

    % for each triangle, each edge
    for triangle_id = 1:numel(tri(:, 1))
        triangle_vertices = tri(triangle_id, :);
        a_f_val = F(triangle_vertices(1));
        b_f_val = F(triangle_vertices(2));
        c_f_val = F(triangle_vertices(3));

        if(sign(real(a_f_val)) ~= sign(real(b_f_val))) || ...
            ((sign(imag(a_f_val)) ~= sign(imag(b_f_val))))
%             display('vertices have different signs for either imag or real parts')
            a_point = [V(triangle_vertices(1), 1) V(triangle_vertices(1), 2)];
            b_point = [V(triangle_vertices(2), 1) V(triangle_vertices(2), 2)];
            if(pdist([a_point; b_point], 'euclidean') > min_distance_r)
                V = [V; [(a_point(1, 1)+b_point(1,1))/2 (a_point(1, 2)+b_point(1,2))/2]];
                is_point_added = true;
            end
        end

        if(sign(real(a_f_val)) ~= sign(real(c_f_val))) || ...
            ((sign(imag(a_f_val)) ~= sign(imag(c_f_val))))
%             display('vertices have different signs for either imag or real parts')
            a_point = [V(triangle_vertices(1), 1) V(triangle_vertices(1), 2)];
            c_point = [V(triangle_vertices(3), 1) V(triangle_vertices(3), 2)];
            if(pdist([a_point; c_point], 'euclidean') > min_distance_r)
                V = [V; [(a_point(1, 1)+c_point(1,1))/2 (a_point(1, 2)+c_point(1,2))/2]];
                is_point_added = true;
            end
        end
        if(sign(real(b_f_val)) ~= sign(real(c_f_val))) || ...
            ((sign(imag(b_f_val)) ~= sign(imag(c_f_val))))
%             display('vertices have different signs for either imag or real parts')
            b_point = [V(triangle_vertices(2), 1) V(triangle_vertices(2), 2)];
            c_point = [V(triangle_vertices(3), 1) V(triangle_vertices(3), 2)];
            if(pdist([b_point; c_point], 'euclidean') > min_distance_r)
                V = [V; [(b_point(1, 1)+c_point(1,1))/2 (b_point(1, 2)+c_point(1,2))/2]];
                is_point_added = true;
            end
        end
    end
end

tri = delaunay(V(:, 1), V(:, 2));
%% Plotting
figure1=figure('Position', [250, 0, 1024, 1024]);
subplot(3, 2, [1 2 3 4])
% triplot(tri,x,y)
triplot(tri, V(:, 1), V(:, 2));
hold on
scatter(real(Gz_zeros), imag(Gz_zeros), 'ro');
scatter(real(Gz_poles), imag(Gz_poles), 'rx');

subplot(3, 2, 5)
step(Gz);
subplot(3, 2, 6)
pzmap(Gz);
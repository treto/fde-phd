% @brief: Verifies if the system is stable using delaunay triangulation 
%
% @param input_function     - input complex function to evaluate for
% stability
% @param USE_VERBOSE_PROFILING - adds lots of profiling info and plots
% @param USE_FILE_SAVE      - saves output to .csv file
% 
% @retval output_is_stable  - boolean value if system is stable
% @retval output_zeros      - list of zeros
function [output_is_stable, output_zeros] = check_stability_using_delaunay_inv_for_fun(input_function, USE_VERBOSE_PROFILING, USE_FILE_SAVE)
close all
%% Auxiliary variables
section_time_log = [];
output_is_stable = true;
local_colormap = hsv(256); %colormap
%% Delaunay 
section_name = 'Section: Delaunay triangulation';
if USE_VERBOSE_PROFILING
    disp(section_name);
end
tic;
% init starting points for Delaunay triangulation
%TODO: there is a possibility that a point on the unit circle will be
%ignored (as circle is approxiamted using limited number of segments)
%ISSUE2: for some reason, changing this by reducing number of points can
%cause the algorithm not to converge on some zeros
V = [sin(0:0.5:2*pi)' cos(0:0.5:2*pi)'];
% defines minimum edge length to continue triang, i.e. defines accuracy
min_distance_r = eps;

% Verifies if edge crosses any two quartiles, also if len is larger than
% resolution, if so then a point between these two vertices is returned
%
% @param edge_vertices - 2 vertices that define a single edge
%
% @retval new_vertice - euclidean average of two vertices on the edge
function new_vertice = evaluate_edge_for_sign_change_and_len(edge_vertices)
    new_vertice = [];
    edge_vert_values = tran_fun_values(edge_vertices);
    if (is_vertices_sign_changed(edge_vert_values(1), edge_vert_values(2)))
         points = V(edge_vertices, :);
         if sqrt(sum(((points(1,:) - points(2,:)).^ 2))) > min_distance_r
             new_vertice = sum(points)/2;
         end
    end
end

function plot_delaunay_convergence(tri, V, V_new, iteration)
     triplot(tri, V(:, 1), V(:, 2), 'color', local_colormap(iteration,:));
     tri = delaunay(V(:, 1), V(:, 2));
     hold on
     scatter(V_new(:, 1), V_new(:, 2), 'kx')
     numel(tri);
     pause(0.05);
end

iter_id = 0;
plot_lim = 1.1;
vert_id_combinations = combnk([1 2 3], 2)'; % all vertice combinations for a triangle
tri = [];
triangle_count = 0;

while (1) % if added any new triangle in this iteration
    if USE_VERBOSE_PROFILING
        display(['Iteration: ', num2str(iter_id)]);
    end
    iter_id = iter_id + 1;
    % each row in tri is a triangle, made of indexes of points in V
    % e.g tri(N) = [100 256 324]
    % V[100] = [0.3 0.4i]
    tri = delaunay(V(:, 1), V(:, 2));
    new_triangle_count = numel(tri);
    if(triangle_count == new_triangle_count)
        disp('breaking!');
        break
    end
    triangle_count = new_triangle_count;
   
    % evaluate characteristic equation value at each triangle vertice
    % z = jw
    tran_fun_values = arrayfun(input_function, V(:,1) + V(:, 2)*1i);
    
%   tri = delaunayTriangulation(V);
%   ISSUE: For some reason, delaunay sometimes produces a "triangle" that is 3
%   points on an ALMOST stright line, we then try to add a point on the
%   edge/2 of this triangle, but it is already included, so the algorithm
%   gets stuck

    V_new = [];
    % for each triangle, each edge
    for triangle_id = 1:numel(tri(:, 1))
        triangle_vertice_ids = tri(triangle_id, :);
        new_vertices = [];
        for vertice_combination = vert_id_combinations
            new_vert = evaluate_edge_for_sign_change_and_len(triangle_vertice_ids(vertice_combination));
            if ~isempty(new_vert)
                new_vertices = [new_vertices; new_vert];
                % TODO: how to only use new vertices?
%                 new_vertices = [new_vertices; new_vert; V(triangle_vertice_ids(vertice_combination), :)];
            end
            
        end
        if ~isempty(new_vertices)
            V_new = [V_new; new_vertices];
            V = [V; new_vertices];
        end
    end
    
    if USE_VERBOSE_PROFILING
         disp(['Vertices (all): ' num2str(numel(V))]);
         disp(['Vertices (used by delaunay): ' num2str(numel(tri))]);
    end
    plot_delaunay_convergence(tri, V, V_new, iter_id);
end

duration = toc;
section_time_log = [section_time_log [section_name duration]];
if USE_VERBOSE_PROFILING
    disp(['Section time: ' num2str(duration)]);
end
%% Evaluation (LEGACY)
% Finding curves C_r and C_i where real or imag part f(z) is close to 0
section_name = 'Section: Curve inf/zero val evaluation';
if USE_VERBOSE_PROFILING
    disp(section_name);
end
tic;
% Curves
% min_distance_r = 0.005;
% eps = 2*min_distance_r;
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
% by the delaunay triangulation; zeroes are inside those triangles
[triangles_near_zeros, triangle_count] = get_triangles_with_edge_len_below_delta(tri, V, min_distance_r);
if USE_VERBOSE_PROFILING
    display(['get_triangles_with_edge_len_below_delta: found triangles ' num2str(triangle_count)])
end
final_triangles = [];
output_zeros = [];
singularities = [];
% For each triangle, calculate phase change based on the vertices
for triangle_id = 1:triangle_count
   triangle_vertices = triangles_near_zeros(triangle_id, :);
   triangle_gravity_center = sum(V(triangle_vertices, 1))/3 + sum(V(triangle_vertices, 2))*1i/3;
   if(abs(triangle_gravity_center) < 1)
%        Only searches for zeros inside the unit circle
         phase_change = calculate_phase_change_for_triangle_given_fun(input_function, V(triangle_vertices, :), eps);
       if(phase_change >= 1)
           final_triangles = [final_triangles; triangles_near_zeros(triangle_id,:)];
           output_zeros = [output_zeros triangle_gravity_center];
           output_is_stable = false;
           if(USE_VERBOSE_PROFILING == false)
               if USE_FILE_SAVE
                   write_delaunay_output(output_is_stable, -1, output_zeros);
               end
               return
           end
       elseif(phase_change <= -1)
           singularities = [singularities triangle_gravity_center];
       end
   end
end

if USE_VERBOSE_PROFILING
    display(['Zero candidates count: ' num2str(numel(output_zeros))])
    display(['Singularities candidates count: ' num2str(numel(singularities))])
end
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
distance_from_origin_for_poles = abs(output_zeros);
if USE_VERBOSE_PROFILING
    disp(['Located system zeros: ' num2str(output_zeros)]);
    if min(distance_from_origin_for_poles) < 1
        disp('The system is unstable, one of the inverted zeros lays inside the unit circle')
    else
        disp('The system is stable, none of the inverted zeros lay inside the unit circle')
    end
end
duration = toc;
section_time_log = [section_time_log [section_name duration]];
if USE_VERBOSE_PROFILING
    disp(['Section time: ' num2str(duration)]);
end
%% Plotting
if(USE_VERBOSE_PROFILING)
    section_name = 'Section: Plotting';
    if USE_VERBOSE_PROFILING
        disp(section_name)
    end
    tic;
    col_count = 3;
    row_count = 2;
    figure1=figure('Position', [0, 0, 1800, 1024]);
    subplot(row_count, col_count, [1])
    triplot(tri, V(:, 1), V(:, 2));
    xlim([-plot_lim plot_lim])
    ylim([-plot_lim plot_lim])
    title('Delaunay triangulation')
    hold on
    aux_x = 0:0.05:2*pi;
    plot(sin(aux_x), cos(aux_x));
    if(numel(C_r) > 0)
        subplot(row_count, col_count, 2)
        scatter(C_r(:, 1), C_r(:, 2), 'g.')
        title('real(f_z) = 0 (C_r)')
        xlim([-plot_lim plot_lim])
        ylim([-plot_lim plot_lim])
        hold on
        plot(sin(aux_x), cos(aux_x), 'k');
    end

    if(numel(C_i) > 0)
        subplot(row_count, col_count, 3)
        scatter(C_i(:, 1), C_i(:, 2), 'y.')
        title('imag(f_z) = 0 (C_r)')
        xlim([-plot_lim plot_lim])
        ylim([-plot_lim plot_lim])
        hold on 
        plot(sin(aux_x), cos(aux_x), 'k');
    end
    
    subplot(row_count, col_count, 4)
%     scatter(real(Gz_zeros), imag(Gz_zeros), 'ro', 'SizeData',48);   
    title('Points of interest - C_r and C_i cross')
    hold on
    if(numel(C_cross) > 0)
        scatter(C_cross(:, 1), C_cross(:, 2), 'b.', 'SizeData', 48)
    end
    xlim([-plot_lim plot_lim])
    ylim([-plot_lim plot_lim])
    hold on
    plot(sin(aux_x), cos(aux_x), 'k');

 %TODO: once we identify new vertices that were added, we should add a
 %distinctive color to those, so that we can draw how algorithm converges
 %to poles
    % Draw all triangles with low edge length, these are then evaluated for
    % zeros or poles using phase count
    subplot(row_count, col_count, 5)
    scatter(V(triangles_near_zeros,1), V(triangles_near_zeros,2), 'b.', 'SizeData', 48);
    hold on
%     scatter(real(Gz_zeros), imag(Gz_zeros), 'ro', 'SizeData',48);   
    title('Triangles low edge length (near zeros)')
    xlim([-plot_lim plot_lim])
    ylim([-plot_lim plot_lim])
    plot(sin(aux_x), cos(aux_x), 'k');

    % Draw poles/zeros of the transfer functions and points located using
    % evaluation
    subplot(row_count, col_count, 6)
    scatter(real(singularities),imag(singularities), 'go', 'SizeData',48);  
    hold on
    scatter(real(output_zeros),imag(output_zeros), 'gx', 'SizeData',48);    
%     scatter(real(Gz_zeros), imag(Gz_zeros), 'ro', 'SizeData',48);   
    title('Triangles around zeros')
    xlim([-plot_lim plot_lim])
    ylim([-plot_lim plot_lim])
    plot(sin(aux_x), cos(aux_x), 'k');

    duration = toc;
    section_time_log = [section_time_log [section_name duration]];
    if USE_VERBOSE_PROFILING
        disp(['Section time: ' num2str(duration)]);
    end
end
if USE_FILE_SAVE
   write_delaunay_output(output_is_stable, -1, output_zeros);
end
end
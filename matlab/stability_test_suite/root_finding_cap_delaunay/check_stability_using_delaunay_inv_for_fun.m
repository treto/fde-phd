% @brief: Verifies if the system is stable using delaunay triangulation 
%
% @param input_function     - input complex function to evaluate for
% stability
% @param USE_VERBOSE_PROFILING - adds lots of profiling info and plots
% @param USE_FILE_SAVE         - saves output to .csv file
% @param USE_EARLY_QUIT        - algorithm stops as soon as a single zero
% is located
% @param USE_FULL_PHASE_CHANGE - if true, then both real and imag parts
% must change sign to add new point, else either is sufficient
% 
% @retval output_is_stable  - boolean value if system is stable
% @retval output_zeros      - list of zeros
function [output_is_stable, output_zeros] = check_stability_using_delaunay_inv_for_fun(input_function, USE_VERBOSE_PROFILING, USE_FILE_SAVE, USE_EARLY_QUIT, USE_FULL_PHASE_CHANGE)
close all
%% Auxiliary variables
section_time_log = [];
output_is_stable = true;
local_colormap = hsv(256); %colormap
if USE_FULL_PHASE_CHANGE
    sign_change_fun_handle = @is_vertices_sign_changed_full_phase_change;
else
    sign_change_fun_handle = @is_vertices_sign_changed_either_real_or_imag;
end

%% Delaunay 
section_name = 'Section: Delaunay triangulation';
if USE_VERBOSE_PROFILING
    disp(section_name);
end
tic;
% init starting points for Delaunay triangulation
%ISSUE2: for some reason, changing this by reducing number of points can
%cause the algorithm not to converge on some zeros
number_of_init_points = 12;
step_init = (2*pi)/number_of_init_points;
V = [sin(0:step_init:2*pi)' cos(0:step_init:2*pi)'];
%As circle is approximated, we need to multiply to ensure that unit circle
%is inside the approximation
mid_point = (V(1,:) + V(2,:))/2;
distance = sqrt(mid_point(1)^2 + mid_point(2)^2);
multiplier = 1/distance; 
V = V*multiplier;

% SUGGESTED VALUES FOR EITHER REAL OR IMAG PHASE CHANGE
% defines minimum edge length to continue triang, i.e. defines accuracy
min_distance_r = eps*100;
% defines how edges are divided into steps for integration to apply
% Cauchy's Arg Principle
% Suggested value: 0.1 (smaller than min_distance_r)
integral_step = 0.1;

% SUGGESTED VALUES FOR FULL PHASE CHANGE
% min_distance_r = 1e-7;

% Verifies if edge crosses any two quartiles, also if len is larger than
% resolution, if so then a point between these two vertices is returned
% This is, in a way, gradient descent-like approach
%
% @param edge_vertices - 2 vertices that define a single edge
%
% @retval new_vertice - euclidean average of two vertices on the edge
% ISSUE: Algorithm can sometimes overshoot a zero if there are zeroes
% close, it will not converge to that zero afterwards
% TODO: Consider adding a point to the middle of a triangle, and not an
% edge, if total phase change in a triangle indicates there is a zero in it
function new_vertice = evaluate_edge_for_sign_change_and_len(edge_vertices)
    new_vertice = [];
    edge_vert_values = tran_fun_values(edge_vertices);
    if (sign_change_fun_handle(edge_vert_values(1), edge_vert_values(2)))
         points = V(edge_vertices, :);
         if sqrt(sum(((points(1,:) - points(2,:)).^ 2))) > min_distance_r
             new_vertice = sum(points)/2;
         end
    end
end

% function new_vertice = add_new_vertice_based_on_triangle_phase(triangle_vertices)
%     new_vertice = [];
%     phase_change = caclculate_phase_change_for_triangle_given_fun_integral(input_function, triangle_vertices, eps);
%     if phase_change >= 1
%         new_vertice = sum(V(triangle_vertices, 1))/3 + sum(V(triangle_vertices, 2))*1i/3;
%     end
% end

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
new_vertices = zeros(1000000,1);

point_added = true;
while (point_added == true) % if added any new triangle in this iteration
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
    tic
    tran_fun_values = arrayfun(input_function, V(:,1) + V(:, 2)*1i);
    toc
    V_new = [];
    tic
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
%             triangle_gravity_center = [sum(V(triangle_vertice_ids, 1))/3 sum(V(triangle_vertice_ids, 2))/3];
            V_new = [V_new; new_vertices];
%             V = V_new;
            V = [V; new_vertices];
            point_added = true;
        end
    end
    toc
    if USE_VERBOSE_PROFILING
         disp(['Vertices (all): ' num2str(numel(V))]);
         disp(['Vertices (used by delaunay): ' num2str(numel(tri))]);
    end
    if ~isempty(V_new)
         plot_delaunay_convergence(tri, V, V_new, iter_id);
    end
end
display(['Iteration count:' num2str(iter_id)])

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
multiplicities = [];
golden_triangles = [];
% For each triangle, calculate phase change based on the vertices
for triangle_id = 1:triangle_count
   triangle_vertices = triangles_near_zeros(triangle_id, :);
   triangle_gravity_center = sum(V(triangle_vertices, 1))/3 + sum(V(triangle_vertices, 2))*1i/3;
   if(abs(triangle_gravity_center) < 1)
%        Only searches for zeros inside the unit circle
%          phase_change = calculate_phase_change_for_triangle_given_fun(input_function, V(triangle_vertices, :), eps);  
       phase_change = caclculate_phase_change_for_triangle_given_fun_integral(input_function, V(triangle_vertices, :), integral_step);
         
%          TODO: depending on the direction, the argument may sum up to -1
%          or 1, the sign depends on this, so possibly should switch to
%          abs(phase_change) instead
       if(abs(phase_change) >= (1 - min_distance_r))
           final_triangles = [final_triangles; triangles_near_zeros(triangle_id,:)];
           golden_triangles = [golden_triangles; V(triangle_vertices, :)];
%            multiplicity = log2(phase_change); #Is it log2 or just
%            phase/2pi?
           multiplicities = [multiplicities abs(phase_change)];
           output_zeros = [output_zeros triangle_gravity_center];
           output_is_stable = false;
           
%            global system_zeros;
%            fname = sprintf('high_order_sys_%d.mat', length(system_zeros));
           fname = sprintf('system_tri_V');
           save(fname, 'tri', 'V');
           
           if USE_EARLY_QUIT
                if USE_FILE_SAVE
                    write_delaunay_output(output_is_stable, -1, output_zeros, multiplicities);
                end
                if USE_VERBOSE_PROFILING
                   display(['(Early quit) system is unstale, zero found at: ' num2str(output_zeros)]);
                end
                return
           end
% %        Singularities are removed
%        elseif(phase_change <= -1)
%            singularities = [singularities triangle_gravity_center multiplicity];
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
    disp(['Zeros multiplicities: ' num2str(multiplicities)]);
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
    aux_x = 0:0.05:(2*pi+0.05);
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
   
    x = -1:0.01:1;
    f_abs = abs(arrayfun(input_function, x + x'*1i));
    f_ang = angle(arrayfun(input_function, x + x'*1i));
    subplot(row_count, col_count, 2)
    h = surf(x, x, f_abs);
    set(h,'LineStyle','none')
    title('Function absolute value')
    xlim([-plot_lim plot_lim])
    ylim([-plot_lim plot_lim])
    colorbar
    
    subplot(row_count, col_count, 3)
    h = surf(x, x, f_ang);
    set(h,'LineStyle','none')
    title('Function argument value')
    xlim([-plot_lim plot_lim])
    ylim([-plot_lim plot_lim])
    colorbar
    hold on
    triplot(tri, V(:, 1), V(:, 2), 'color', 'k');
    
    if USE_VERBOSE_PROFILING
        disp(['Section time: ' num2str(duration)]);
    end
    
end

if USE_FILE_SAVE
   write_delaunay_output(output_is_stable, -1, output_zeros, multiplicities);
end
end
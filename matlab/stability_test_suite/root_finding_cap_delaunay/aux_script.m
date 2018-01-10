close all
clc
clear all
%% Auxiliary variables
USE_VERBOSE_PROFILING = 1;
section_time_log = [];
output_is_stable = true;
output_zeros = [];
%% Delaunay 
section_name = 'Section: Delaunay triangulation';
if USE_VERBOSE_PROFILING
    disp(section_name);
end
tic;
% init starting points for Delaunay triangulation
V = [sin(0:0.5:2*pi)' cos(0:0.5:2*pi)'];
% defines minimum edge length to continue triang, i.e. defines accuracy
min_distance_r = 0.01;
iter_id = 0;
is_point_added = true;
plot_lim = 1.1;
% all combinations
vert_id_combinations = combnk([1 2 3], 2)';
tri = [];
% the first is never false, fix it
while is_point_added == true% && iter_id < 10
    if USE_VERBOSE_PROFILING
        display(['Iteration: ', num2str(iter_id)]);
    end
    iter_id = iter_id + 1;
    is_point_added = false;
    % evaluate characteristic equation value at each triangle vertice
    % z = jw
    tran_fun_values = arrayfun(@sample_eval_func, V(:,1) + V(:, 2)*1i);
    % each row in tri is a triangle, made of indexes of points in V
    % e.g tri(N) = [100 256 324]
    % V[100] = [0.3 0.4i]
    tri = [];
%     tri = delaunayTriangulation(V);
%     tri = DelaunayTri(V);
    tri = delaunay(V(:, 1), V(:, 2));
    triangle_count = numel(tri);

    V_new = [];
    % for each triangle, each edge
    for triangle_id = 1:numel(tri(:, 1))
        triangle_vertice_ids = tri(triangle_id, :);
        new_vertices = [];
        for vertice_combination = vert_id_combinations
            edge_vertices = triangle_vertice_ids(vertice_combination);
            new_vertice = [];
            edge_vert_values = tran_fun_values(edge_vertices);
            if (is_vertices_sign_changed(edge_vert_values(1), edge_vert_values(2)))
                 points = V(edge_vertices, :);
                 if sqrt(sum(((points(1,:) - points(2,:)).^ 2))) > min_distance_r
                     disp('new point');
        %              disp('iteration in ev edge');
%                      points(1,:)
%                      points(2,:)
%                      sqrt(sum(((points(1,:) - points(2,:)).^ 2)))
                     new_vertice = [(points(1, 1)+points(2,1))/2 (points(1, 2)+points(2,2))/2];
        %              new_vertice = sum(points)/2;
                     new_vertices = [new_vertices; new_vertice];
                 end
            end
        end
        
        if ~isempty(new_vertices)
            is_point_added = true;            
            display('not empty!');
            V_new = [V_new; new_vertices];
            V = [V; new_vertices];
        end
%         is_point_added = true;
    end
%     V((end-10):end,:)
    disp(['Total number of vertices: ' num2str(numel(V))]);
%     disp(['New vertices: ' num2str(new_vertices)]);
%     V_new
    clf
    triplot(tri, V(:, 1), V(:, 2));
    tri = delaunay(V(:, 1), V(:, 2));
    hold on
    scatter(V_new(:, 1), V_new(:, 2), 'r.')
    numel(tri)
    pause(1);
    tri = delaunay(V(:, 1), V(:, 2));
    if numel(tri) == triangle_count
        is_point_added = false;
    end
    
%     system pause
end



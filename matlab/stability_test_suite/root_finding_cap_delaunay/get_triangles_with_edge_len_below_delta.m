% @brief: Checks if a sign change in realis or imaginaris parts of the two
% complex values has occured
% 
% @param input_x complex value
% @param input_y complex value
%
% @retval boolean value, true if sign changed, false otherwise
function [found_triangles, triangle_count] = get_triangles_with_edge_len_below_delta(triangle_vertices_ids, vertices, min_distance_r)
    found_triangles = [];
    for triangle_id = 1:numel(triangle_vertices_ids(:, 1))
        triangle_vertice_ids = triangle_vertices_ids(triangle_id, :);
        triangle = vertices([triangle_vertice_ids], :);
        edge_len = pdist(triangle,'euclidean');
    %     TODO: the if statement probably needs some tweaking not to miss
    %     anything
        if(max(edge_len) < (2*min_distance_r))
            found_triangles = [found_triangles; triangle_vertice_ids];
        end
    end    
    triangle_count = size(found_triangles);
    triangle_count = triangle_count(1);
end
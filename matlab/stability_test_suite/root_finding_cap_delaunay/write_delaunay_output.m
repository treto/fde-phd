function write_delaunay_output(is_stable, duration, zeros, multiplicities)
    fid = fopen('OUTPUT.csv', 'a') ;
    
%     for iLine = 1:size(Data, 1) % Loop through each time/value row
%        fprintf(fid, '%s1,', Time{iLine}) ; % Print the time string
%        fprintf(fid, '%12.3f, %12.3f\n', Data(iLine, 1:2)) ; % Print the data values
%     end
    fprintf(fid, 'timestamp,%s,is_stable,%d,duration,%d,zeros,', datestr(now,'HH:MM:SS.FFF'), is_stable, duration)
    zero_and_multiplicities = [zeros' multiplicities'];
    zero_and_multiplicities = reshape(zero_and_multiplicities, 1,  numel(zero_and_multiplicities));
    dlmwrite('OUTPUT.csv', zero_and_multiplicities, '-append') ;
%     dlmwrite('OUTPUT.csv', '-append') ;
%     fprintf(fid, 
    fclose(fid) ;
%     dlmwrite('OUTPUT.csv', [char(datestr(now,'HH:MM:SS.FFF')) is_stable duration zeros],'delimiter',',');
end


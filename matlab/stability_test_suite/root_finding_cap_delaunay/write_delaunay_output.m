function write_delaunay_output(is_stable, duration, zeros)
    fid = fopen('OUTPUT.csv', 'a') ;
    
%     for iLine = 1:size(Data, 1) % Loop through each time/value row
%        fprintf(fid, '%s1,', Time{iLine}) ; % Print the time string
%        fprintf(fid, '%12.3f, %12.3f\n', Data(iLine, 1:2)) ; % Print the data values
%     end
    fprintf(fid, 'timestamp,%s,is_stable,%d,duration,%d,zeros,', datestr(now,'HH:MM:SS.FFF'), is_stable, duration)
    dlmwrite('OUTPUT.csv', zeros, '-append') ;
%     fprintf(fid, 
    fclose(fid) ;
%     dlmwrite('OUTPUT.csv', [char(datestr(now,'HH:MM:SS.FFF')) is_stable duration zeros],'delimiter',',');
end


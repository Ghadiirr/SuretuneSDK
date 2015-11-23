function [ changes ] = SDK_removecomments( folder,file )
%SDK_REMOVECOMMENTS Summary of this function goes here
%   Detailed explanation goes here
        
    
    fin = fopen(fullfile(folder,file));
    fout = fopen(fullfile(folder,[file(1:end-4),'_nocomments',file(end-3:end)]),'w+');

    changes = 0;
    
    while ~feof(fin)
       s = fgetl(fin);
       
       if ~isempty(strfind(s,'<!'))
           changes = 1;
           s = '';
       end
           
           
       

       fprintf(fout,'%s',s);
    end

    fclose(fin);
    fclose(fout);
    
    if ~changes
        delete(fullfile(folder,[file(1:end-4),'_nocomments',file(end-3:end)]))
    end



end


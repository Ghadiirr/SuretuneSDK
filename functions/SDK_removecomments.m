function [changes] = SDK_removecomments(fullFileName)
%SDK_REMOVECOMMENTS Summary of this function goes here
%   Detailed explanation goes here
        
fin = fopen(fullFileName);
fout = fopen([fullFileName(1:end-4),'_nocomments.xml'],'w+');

changes = false;
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
   delete([fullFileName(1:end-4),'_nocomments.xml'])
end

end
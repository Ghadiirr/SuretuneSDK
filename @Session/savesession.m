function savesession(obj,destination)
if nargin==1
    folder = 0;
end

if nargin==2
    [folder,filename] = fileparts(destination);
end
    

% make a temp dir
tempfoldername = tempname;
mkdir(tempfoldername)
cd(tempfoldername)


% Save Sessions:
SDK_session2xml(obj.sessionData,[obj.ver,'.xml'])
SDK_session2xml(obj.originalSessionData,'OriginalSession.xml')

% Save Meshes:
for iMesh = 1:numel(obj.meshStorage.list);
    obj.meshStorage.list{iMesh}.savetofolder('Meshes')
    
    % Also save the mesh to meshstorage:
%     vertface2obj( obj.meshStorage.list{iMesh}.v, obj.meshStorage.list{iMesh}.f,[obj.sureTune,'MeshStorage/',obj.meshStorage.list{iMesh}.fileName])
end

% Save new Volumes
for iVolume = 1:numel(obj.volumeStorage.list);
    
    obj.volumeStorage.list{iVolume}.savetofolder(fullfile('Volumes',obj.volumeStorage.names{iVolume}));
end

% Make an empty 'Sessions' folder. Since SureTune is expecting that.
mkdir('Sessions');

% Export log
table = cell2table(obj.log,'VariableNames',{'datetime','action'});
writetable(table,fullfile('Log.txt'),'Delimiter','\t')

% Zip session:
disp('Zipping Session...')
eval(['! "',fullfile(obj.homeFolder,'thirdParty','7za.exe'),'" a -tzip -r -bd -- session.zip ']); %-xr@Log.txt -xr@OriginalSession.xml

SDK_embedzipindicom(obj,tempfoldername);


% copy dicom to removable drive
if ~folder
    folder = SDK_detectexternaldrive('save');
end
if ~folder
    folder = uigetdir('Select, or make, a DICOM folder on a removable drive.');
end
if isempty(filename)
copyfile(fullfile(tempfoldername,'newSession.dcm'),fullfile(folder,[obj.patient.name,'_',strrep(strrep(datestr(datetime),':',''),' ','_'),'.dcm']));
else
    copyfile(fullfile(tempfoldername,'newSession.dcm'),fullfile(folder,[filename,'.dcm']));
end
fclose('all');

cd(folder);

% remove the temp dir
rmdir(tempfoldername,'s');


% 
% %copy the generic header to folder
% copyfile(fullfile(obj.homeFolder,'@session','dcmtemplate.dcm'),fullfile(folder,'header.bin'));
% 
% %write a small file with the fileszie
% % 
% f = dir('session.zip');
% bytes = f.bytes
% endingbin = fopen('ending.bin','w+');
% addending = 0;
% if mod(bytes,2)
%     bytes = bytes+1;
%     fwrite(endingbin,0,'uint8');
%     addending = 1;
% end
% fclose(endingbin);
% 
%     sizebin = fopen('sizebin.bin','w+');
%     fwrite(sizebin,bytes,'uint');
%     fclose(sizebin);
% 
% % merge the files
% fclose('all');
% if addending
%     eval('! copy /b header.bin + sizebin.bin + session.zip + ending.bin newSession.dcm') 
% else
%     eval('! copy /b header.bin + sizebin.bin + session.zip newSession.dcm') 
% end
% 



end

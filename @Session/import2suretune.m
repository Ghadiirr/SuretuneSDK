function import2suretune(obj)
% IMPORT2SURETUNE is an @Session function. It sends a SessionInstance to
% Suretune. This is a developers function and will probably be removed in
% a future version.

disp('Saving Files...')

if isempty(obj.directory)
    warning('No Session was loaded')
    return
end

thisdir = pwd;
cd(obj.directory)


% Save Sessions:
SDK_session2xml(obj.sessionData,[obj.ver,'.xml'])
SDK_session2xml(obj.originalSessionData,'OriginalSession.xml')

% Save Meshes:
for iMesh = 1:numel(obj.meshStorage.list);
    obj.meshStorage.list{iMesh}.savetofolder('Meshes')
    
    % Also save the mesh to meshstorage:
    vertface2obj( obj.meshStorage.list{iMesh}.v, obj.meshStorage.list{iMesh}.f,fullfile(obj.sureTune,'MeshStorage',obj.meshStorage.list{iMesh}.fileName))
end

% Save new Volumes
for iVolume = 1:numel(obj.volumeStorage.list);
    
    obj.volumeStorage.list{iVolume}.savetofolder(fullfile('Volumes',obj.volumeStorage.names{iVolume}));
end

% Export log
table = cell2table(obj.log,'VariableNames',{'datetime','action'});
writetable(table,fullfile(obj.directory,'Log.txt'),'Delimiter','\t')

% Zip session:
disp('Zipping Session...')
eval(['!',fullfile(obj.homeFolder,'thirdParty','7za.exe'),' a -tzip -r -bd -- session.zip ']); %-xr@Log.txt -xr@OriginalSession.xml


%Import
disp('Importing Session To SureTune')
cd(obj.sureTune)
fclose all;
eval(['!SuretuneArchive.exe /importsessions ',fullfile(obj.directory,'session.zip')])
cd(thisdir)

end
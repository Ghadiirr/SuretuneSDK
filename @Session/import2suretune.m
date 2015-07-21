function import2suretune(obj)
disp('Saving Files...')

if isempty(obj.directory)
    warning('No Session was loaded')
    return
end

thisdir = pwd;
cd(obj.directory)


% Save Sessions:
SDK_session2xml(obj.sessionData,'SureTune2Sessions.xml')
SDK_session2xml(obj.originalSessionData,'OriginalSession.xml')

% Save Meshes:
for iMesh = 1:numel(obj.meshStorage.list);
    obj.meshStorage.list{iMesh}.savetofolder('Meshes')
    
    % Also save the mesh to meshstorage:
    vertface2obj( obj.meshStorage.list{iMesh}.v, obj.meshStorage.list{iMesh}.f,[obj.sureTune,'MeshStorage/',obj.meshStorage.list{iMesh}.fileName])
end

% Save new Volumes
for iVolume = 1:numel(obj.volumeStorage.list);
    
    obj.volumeStorage.list{iVolume}.savetofolder(['Volumes/',obj.volumeStorage.names{iVolume}]);
end

% Export log
table = cell2table(obj.log,'VariableNames',{'datetime','action'});
writetable(table,[obj.directory,'/Log.txt'],'Delimiter','\t')

% Zip session:
disp('Zipping Session...')
eval('!C:/MATLAB-Addons/SDK/7za.exe a -tzip -r -bd -- session.zip '); %-xr@Log.txt -xr@OriginalSession.xml


%Import
disp('Importing Session To SureTune')
cd(obj.sureTune)
fclose all;
eval(['!SureplanArchive.exe /noencryption /importsessions ',obj.directory,'session.zip'])
cd(thisdir)

end
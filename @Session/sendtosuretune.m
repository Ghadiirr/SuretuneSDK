function [ output_args ] = sendtosuretune( obj,choice )
%SENDTOSURETUNE Summary of this function goes here
%   Detailed explanation goes here
currentdir = pwd;
try
    load('networkconfig.mat')
catch
    disp('No networkconfig could be found.')
    
    if exist('C:\Program Files (x86)\DicomUtils\dcmtk\bin\storescu.exe', 'file') == 2
        networkconfig.dicomutils = 'C:\Program Files (x86)\DicomUtils\dcmtk\bin\storescu.exe';
    else
        answer = questdlg('For this function, DicomUtils needs to be installed. If you have installed DicomUtils already press Yes to locate the file.');
        switch answer
            case 'yes'
                [filename,pathname] = uigetfile('storescu.exe');
                networkconfig.dicomutils = fullfile(pathname,filename);
                
            otherwise
                disp('Aborted by user')
                return
        end
    end
    
    networkconfig.recipient = [];
end

if nargin==1

    iRec = 0;
    for iRec = 1:numel(networkconfig.recipient)
        fprintf('\t%d.\t%s (%s:%d)\n',iRec,networkconfig.recipient(iRec).label,networkconfig.recipient(iRec).id,networkconfig.recipient(iRec).port)
    end
    fprintf('\t%d.\tAdd new...\n',iRec+1);

    choice = input('Select index: ');
end

if choice > numel(networkconfig.recipient)
    idx = numel(networkconfig.recipient)+1;
    networkconfig.recipient(idx).label = input('Label: ','s');
    networkconfig.recipient(idx).id = input('IP: ','s');
    networkconfig.recipient(idx).port = input('Port: ');
    save(fullfile(obj.homeFolder,'@Session','networkconfig'),'networkconfig')
end



%% SAVE IT

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
eval(['!',fullfile(obj.homeFolder,'thirdParty','7za.exe'),' a -tzip -r -bd -- session.zip ']); %-xr@Log.txt -xr@OriginalSession.xml

SDK_embedzipindicom(obj,tempfoldername);



%% PUSH IT

eval(['!"',networkconfig.dicomutils,'" -v ',networkconfig.recipient(choice).id,' ',num2str(networkconfig.recipient(choice).port),' ', fullfile(tempfoldername,'newSession.dcm')]);


cd(currentdir);
% remove the temp dir
rmdir(tempfoldername,'s');


    

end
    


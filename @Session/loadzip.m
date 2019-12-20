function loadzip(obj,file)
% LOADZIP is a @Session function. It loads a zipped Session to MATLAB.
%   [] = SessionObject.loadzip()  <-- throws uigetfile dialog
%   [] = SessionObject.loadzip(path)  <-- skips dialog
%
%   
warning('off','all');
%get PathName
if nargin==1;
    [fileName,pathName] = uigetfile('.zip');
    if not(fileName)
        disp('Aborted by user')
        return
    end
    file = fullfile(pathName,fileName);
end

if ispc
    if ~exist(fullfile(obj.homeFolder,'thirdParty','7za.exe'))
        error('7zip could not be found!')
    end
end

%Unzip
if ispc
    eval(['!"',fullfile(obj.homeFolder,'thirdParty','7za.exe"'),' x -bd -y "',file,'" -o"',file(1:end-4),'"']);
    unpackedDir = file(1:end-4);
elseif ismac
    %msgbox('Please select the folder with the unzipped version of this session')
    %get file location
    [filepath,name,ext] = fileparts(file);
    unzipFolder = '/Users/jonas/MatlabTemp';
    mkdir(fullfile(unzipFolder,name))
   
    copyfile(fullfile(filepath,[name,'.dcm']),fullfile(unzipFolder,name,[name,'.dcm']));
    

    
    str =  ['! "/Users/jonas/MatlabTemp/p7zip_16.02/bin/7za"',' x -bd -y "',fullfile(unzipFolder,name,[name,'.dcm']),'" -o"',fullfile(unzipFolder,name),'"'];
    [a,b ]= system(str);
    unpackedDir = fullfile(unzipFolder,name);
    disp('unzipping...')
elseif isunix
    eval(['!"',fullfile(obj.homeFolder,'thirdParty','unar"'),file,' -f -o',file(1:end-4)]);    
else
    error('Operating system is not supported')
end

for attempt = 1:60
    try
        obj.updateXml = 0;
        %Index Volumes
        if obj.developerFlags.loadVolumes
            obj.loadvolumes(fullfile(unpackedDir,'Volumes'));
            succes = 1;
        end
        break
        
    catch
        disp(['waiting  ',num2str(attempt), '...'])
        pause(1)
        succes = 0;
        
    end
end

if not(succes)
    error('Unzipping aborted. Time limit was exceeded.')
end


%Load Meshes
obj.loadmeshes(fullfile(unpackedDir,'Meshes'));

%detectsuretuneversion
ver = detectsuretuneversion(unpackedDir);
obj.ver = ver;

%Load XML
obj.loadxml(unpackedDir,[ver,'.xml'])

%Load Stimplans
obj.loadtherapyplans(unpackedDir);

%Load Manual Segmentations
%Load Meshes
obj.loadmeshes(fullfile(unpackedDir,'Sessions',obj.getsessionname,'Segmentations'));




obj.updateXml = 1;

    function ver = detectsuretuneversion(folder)
        if exist(fullfile(folder,'SureTune2Sessions.xml'),'file')
            ver = 'SureTune2Sessions';
        elseif exist(fullfile(folder,'SureTune3Sessions.xml'),'file')
            ver = 'SureTune3Sessions';
        else
            error('Could not find Session Data')
        end
        
    end

%Delete temp dir
if ismac
rmdir(unpackedDir,'s' )
end
warning('on','all');
end
function loadzip(obj,file)
% LOADZIP is a @Session function. It loads a zipped Session to MATLAB.
%   [] = SessionObject.loadzip()  <-- throws uigetfile dialog
%   [] = SessionObject.loadzip(path)  <-- skips dialog
%
%   

%get PathName
if nargin==1;
    [fileName,pathName] = uigetfile('.zip');
    if not(fileName)
        disp('Aborted by user')
        return
    end
    file = fullfile(pathName,fileName);
end

if ~exist(fullfile(obj.homeFolder,'thirdParty','7za.exe'))
    error('7zip could not be found!')
end


%Unzip
if ispc
    eval(['!"',fullfile(obj.homeFolder,'thirdParty','7za.exe"'),' x -bd -y "',file,'" -o"',file(1:end-4),'"']);
elseif isunix
    eval(['!"',fullfile(obj.homeFolder,'thirdParty','unar"'),file,' -f -o',file(1:end-4)]);    
else
    error('Operating system is not supported')
end

obj.updateXml = 0;
%Index Volumes
if obj.developerFlags.loadVolumes
    obj.loadvolumes(fullfile(file(1:end-4),'Volumes'));
end

%Load Meshes
obj.loadmeshes(fullfile(file(1:end-4),'Meshes'));

%detectsuretuneversion
ver = detectsuretuneversion(file(1:end-4));
obj.ver = ver;

%Load XML
obj.loadxml(file(1:end-4),[ver,'.xml'])

%Load Stimplans
obj.loadtherapyplans(file(1:end-4));

%Load Manual Segmentations
%Load Meshes
obj.loadmeshes(fullfile(file(1:end-4),'Sessions',obj.getsessionname,'Segmentations'));




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

end
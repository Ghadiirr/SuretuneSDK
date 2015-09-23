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
eval(['!"',fullfile(obj.homeFolder,'thirdParty','7za.exe"'),' x -bd -y ',file,' -o',file(1:end-4)]);

obj.updateXml = 0;
%Index Volumes
obj.loadvolumes(fullfile(file(1:end-4),'Volumes'));

%Load Meshes
obj.loadmeshes(fullfile(file(1:end-4),'Meshes'));

%Load XML
obj.loadxml([file(1:end-4),'\'],'SureTune2Sessions.xml')

%Load Stimplans
obj.loadtherapyplans(file(1:end-4));

%Load Manual Segmentations
%Load Meshes
obj.loadmeshes(fullfile(file(1:end-4),'Sessions',obj.getsessionname,'Segmentations'));


obj.updateXml = 1;

end
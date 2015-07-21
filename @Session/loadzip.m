function loadzip(obj,file)

%get PathName
if nargin==1;
    [fileName,pathName] = uigetfile('.zip');
    if not(fileName)
        disp('Aborted by user')
        return
    end
    file = [pathName,fileName];
end


%Unzip
eval(['!C:/MATLAB-Addons/SDK/7za.exe x -bd -y ',file,' -o',file(1:end-4)]);

%Index Volumes
obj.loadvolumes(fullfile(file(1:end-4),'Volumes'));

%Load Meshes
obj.loadmeshes(fullfile(file(1:end-4),'Meshes'));

%Load XML
obj.loadxml([file(1:end-4),'\'],'SureTune2Sessions.xml')

%Load Stimplans
obj.loadtherapyplans(file(1:end-4));

obj.updateXml = 1;

end
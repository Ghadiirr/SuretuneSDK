[installationdir,~] = fileparts(mfilename('fullpath'));

%add all subfolders to path
addpath(genpath(installationdir));
warning('off','all')
clc

%see if *.mdt is not yet removed
if exist(fullfile(installationdir,'thirdParty','7za.exe.mdt'))
    movefile(fullfile(installationdir,'thirdParty','7za.exe.mdt'),...
            fullfile(installationdir,'thirdParty','7za.exe'));
end

if exist(fullfile(installationdir,'thirdParty','Network','storescp.mdt'))
    movefile(fullfile(installationdir,'thirdParty','Network','storescp.mdt'),...
            fullfile(installationdir,'thirdParty','Network','storescp.exe'));
end

if exist(fullfile(installationdir,'thirdParty','Network','pskill.mdt'))
    movefile(fullfile(installationdir,'thirdParty','Network','pskill.mdt'),...
            fullfile(installationdir,'thirdParty','Network','pskill.exe'));
end


loadSDK
VNA2NIFTI_GUI



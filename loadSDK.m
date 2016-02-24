[installationdir,~] = fileparts(mfilename('fullpath'));

%add all subfolders to path
addpath(genpath(installationdir));
clc
fprintf('SDK is ready to use!\nTo get started run helpSDK.\n\n~ Kind regards, Jonas \n\t\tjonas.roothans@medtronic.com\n\n(This is still work in progress, so please contact me if you have any difficulties)\n')

thisdir = pwd;
cd (installationdir)
[~,message] = system('git fetch --verbose');
if isempty(strfind(message,'[up to date]'))
    GITreclone
end



    cd(thisdir)


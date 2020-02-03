[installationdir,~] = fileparts(mfilename('fullpath'));

%add all subfolders to path
addpath(genpath(installationdir));
warning('off','all')

loadSDK
unpacksuretune
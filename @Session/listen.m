function [  ] = listen( obj )
%LISTEN Summary of this function goes here
%   Detailed explanation goes here

thisdir = fileparts(mfilename('fullpath'));
if ~exist(fullfile(obj.homeFolder,'thirdParty','Network'))
    disp('Network add-on is not installed.')
    return
end
exedir = fullfile(obj.homeFolder,'thirdParty','Network','storescp');



%wait for session in new temp folder
tempfoldername = tempname;
mkdir(tempfoldername)

cd(tempfoldername)


%% Start listening
disp('Listening...')
eval(['!',exedir,' -v 3010 -xcr "pskill storescp"']);

filename = dir('RAW*');
obj.loadsession(fullfile(pwd,filename.name))

cd(obj.homeFolder);
rmdir(tempfoldername,'s'); %also remove subdirs






end


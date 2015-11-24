function [  ] = listen( obj )
%LISTEN Summary of this function goes here
%   Detailed explanation goes here

thisdir = fileparts(mfilename('fullpath'));
exedir = fullfile(thisdir(1:strfind(thisdir,'@')-1),'thirdParty','Network','storescp');



%wait for session in new temp folder
tempfoldername = tempname;
mkdir(tempfoldername)

cd(tempfoldername)


%% Start listening
disp('Listening...')
eval(['!',exedir,' -v 3010 -xcr "pskill storescp"']);

filename = dir('RAW*');
obj.loadsession(fullfile(pwd,filename.name))






end


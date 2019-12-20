function [outputArg1,outputArg2] = install(obj)
%INSTALL Summary of this function goes here
%   Detailed explanation goes here
     fullpath = mfilename('fullpath');
    homeFolder = fullpath(1:findstr(fullpath,'@Session')-2);
    waitfor(msgbox('Select or make folder for unzipping sessions'))
    unzipsessiondir = uigetdir();
    
    if ismac 
        disp('installing tool that will open sessions...')
        unzip(fullfile(homeFolder,'thirdParty','iOS_7z.zip'),unzipsessiondir)
    end
    
    settings.unzipdir = unzipsessiondir;
    
    save(fullfile(homeFolder,'SDKsettings.mat'),'settings')

end


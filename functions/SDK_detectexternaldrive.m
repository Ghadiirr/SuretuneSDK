function [ folder ] = SDK_detectexternaldrive(loadsave)
%SDK_DETECTEXTERNALDRIVE Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    switch loadsave
        case 'load'
            directory = 'SureTune2Sessions';
        case 'save'
            directory = 'DICOM';
    end
else
    folder = pwd;
    return
end


% do not scan for a,b or c
driveletters = ('D':'Z'); 

for drive = 1:numel(driveletters)
    if exist(fullfile([driveletters(drive),':'],directory),'dir')
        folder = fullfile([driveletters(drive),':'],directory);
        return
    end
end

switch loadsave
    case 'load'
        folder = pwd;
    case 'save'
        disp('No external drive with a DICOM folder could be found.')
        folder =0;
end



end


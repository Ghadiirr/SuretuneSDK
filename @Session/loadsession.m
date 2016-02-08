function loadsession(obj,file, includeVolumes )
% LOADSEDSSION is a @Session function. It loads a zipped Session inside a DICOM to MATLAB.
%   [] = SessionObject.loadsession()  <-- throws uigetfile dialog
%   [] = SessionObject.loadsession(path)  <-- skips dialog
%
%   

%get PathName
if nargin==1;
    
    startingfolder = SDK_detectexternaldrive('load');
    [fileName,pathName] = uigetfile({'*.dcm;*.zip','SureTune Session Files (*.dcm,*.zip)'}, 'Pick a file',startingfolder);
    if not(fileName)
        disp('Aborted by user')
        return
    end
    file = fullfile(pathName,fileName);
    
    includeVolumes = 1;
    
elseif nargin==2
    includeVolumes = 1;
    
end
    
disp('Loading file..')

obj.loadzip(file,includeVolumes)

% Delete created folder
if delFolderAfterLoading ==1
    disp('Deleting temporary folder...')
    [path, filename, ~] = fileparts(file);
    
    rmpath(genpath([path,'\',filename,'\']))
    rmdir([path,'\',filename,'\'],'s')
    
end

disp('Done')
end

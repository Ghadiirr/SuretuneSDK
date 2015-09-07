function importfromsuretune(obj, wildcard)
% IMPORTFROM SURETUNE is an @Session developers function. This function
% will be deleted in future versions. 
%   SessionObject.importfromsuretune(wildcard) retrieves a session from
%   suretune.
%   * wildcard: a (sub)string. for instance *001* including the asterisk(*).


if nargin==1
    disp('input arguments: wildcard')
    disp('wildcard: ''*01*'' to filter on filenames that contain 01')
    return
end
%                 thisdir = pwd;

fileName = 'MATLABinput.zip';

% Browse to SureTune folder:
cd(obj.sureTune)
if exist(fileName,'file');delete(fileName);end
if exist('MATLABinput','dir');rmdir('MATLABinput','s');end
eval(['!SureplanArchive.exe /noencryption /patientname "',wildcard,'" /exportsessions ',fileName])

obj.loadzip(fullfile(obj.sureTune,fileName))

%                 %Revert to original directory
%                 cd(thisdir)
end
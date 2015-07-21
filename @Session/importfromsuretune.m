function importfromsuretune(obj, wildcard)

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

obj.loadzip([obj.sureTune,fileName])

%                 %Revert to original directory
%                 cd(thisdir)
end
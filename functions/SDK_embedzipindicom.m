function [  ] = SDK_embedzipindicom( obj,tempfoldername )
%SDK_EMBEDZIPINDICOM Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    tempfoldername = pwd;
elseif nargin==2
    cd(tempfoldername)
end

% make/copy additional files

f = dir('session.zip');
bytes = f.bytes;
endingbin = fopen('ending.bin','w+');
addending = 0;
if mod(bytes,2)
    bytes = bytes+1;
    fwrite(endingbin,0,'uint8');
    addending = 1;
end
fclose(endingbin);

    sizebin = fopen('sizebin.bin','w+');
    fwrite(sizebin,bytes,'uint');
    fclose(sizebin);
    
    
%copy the generic header to folder
copyfile(fullfile(obj.homeFolder,'functions','dcmtemplate.dcm'),fullfile(tempfoldername,'header.bin'));    

% bake it into a dicom

fclose('all');
if addending
    eval('! copy /b header.bin + sizebin.bin + session.zip + ending.bin newSession.dcm') 
else
    eval('! copy /b header.bin + sizebin.bin + session.zip newSession.dcm') 
end

if ~isempty(obj.sureTune) &&  obj.developerFlags.upgrade
    disp('Upgrading Session')
    thisdir = pwd;
    cd(obj.sureTune)
    [~,text] = system(['SureTuneArchive.exe',' /stu2 /upgradesessions "',fullfile(thisdir,'newSession.dcm'),'"']);
    disp(text)
    cd(thisdir)
    
end


end


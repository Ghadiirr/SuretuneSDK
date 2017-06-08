function [ output_args ] = SDK_upgradefolder( obj, dir,flag )

if nargin==3
    switch flag
        case 'stu2'
            stuflag = '\stu';
        case 'stu3'
            stuflag = '';
        otherwise
            stuflag = '';
    end
else
    stuflag = '';
end


if ~isempty(obj.sureTune)
    disp('Upgrading Session')
    thisdir = pwd;
    cd(obj.sureTune)
    [~,text] = system(['SureTuneArchive.exe',stuflag,' /upgradesessions "',dir,'"']);
    disp(text)
    cd(thisdir)
    
end

end


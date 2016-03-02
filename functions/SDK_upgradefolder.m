function [ output_args ] = SDK_upgradefolder( obj, dir )


if ~isempty(obj.sureTune) 
    disp('Upgrading Session')
    thisdir = pwd;
    cd(obj.sureTune)
    [~,text] = system(['SureTuneArchive.exe',' /upgradesessions "',dir,'"']);
    disp(text)
    cd(thisdir)
    
end

end


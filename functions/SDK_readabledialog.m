function [ output ] = SDK_readabledialog( S )
%SDK_READABLE Summary of this function goes here
%   Detailed explanation goes here

if S.developerFlags.readable
    switch questdlg(sprintf('This modification might make your session incompatible with SureTune.\nDo you wish to continue?'),'SureTune warning','Yes','Yes to all','No','No') 
        case 'Yes'
            output = 1;
            S.addtolog('The following action might make this session incompatible with Suretune:')
        case 'Yes to all'
            S.developerFlags.readable = 0;
            output = 1;
            S.addtolog('The following action might make this session incompatible with Suretune:')
        case 'No'
            output = 0;
        case ''
            output =0;
    end
else
    output = 1;

end


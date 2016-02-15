function [ proceed ] = SDK_proceeddialog( obj, warningstring)
%SDK_YESNODIALOG Summary of this function goes here
%   Detailed explanation goes here
if nargin==1
    warningstring = 'Are you sure?';
end

if ~obj.developerFlags.skipWarning 
    button = questdlg(warningstring,'Do you want to proceed?','Yes') ;
    switch button
        case 'Yes'
            proceed = 1;
        case 'No'
            proceed = 0;
        case 'Cancel'
            error('Script aborted - User pressed cancel.')
        case ''
            proceed = 0;
    end
else
    proceed = 1;
end
    
    

end


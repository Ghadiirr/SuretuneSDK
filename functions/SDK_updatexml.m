function [  ] = SDK_updatexml(obj,Component,field_address,newValue,description)
%SDK_UPDATEXML Summary of this function goes here
%   Detailed explanation goes here

if ~obj.updateXml;return;end


Component_address = Component.path;
address = [Component_address,field_address];

try
    oldValue = eval(address);
    if SDK_isregisterable(oldValue)
        oldValue = oldValue.matlabId;
    end
catch
    oldValue = ' [nothing] ';
end




if isstruct(newValue)
    evalthis = [address,' = newValue;'];
    eval(evalthis);
    newValue = '[1x1 Structure]';
    if isstruct(oldValue)
        oldValue = '[1x1 Structure]';
    end;
else
    evalthis = [address,' = ''',num2str(newValue),''';'];
    eval(evalthis);
end


%if it is not a registerable (such as a stimplan) no matlab Id exists
if ~isfield(Component,'matlabId')
    Id = '';
else 
    Id = Component.matlabId;
end

if nargin==4
    obj.addtolog('Changed %s from %s to %s for %s (%s).',field_address,oldValue,num2str(newValue),Id,class(Component));
else
    

%Update Log
try
obj.addtolog('Changed %s from %s to %s for %s (%s).',description,oldValue,num2str(newValue),Id,class(Component));
catch
    warning('Could not log')
end
end
end



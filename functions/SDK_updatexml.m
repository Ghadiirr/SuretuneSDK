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

evalthis = [address,' = ''',num2str(newValue),''';'];
eval(evalthis);



if nargin==4
    obj.addtolog('Changed %s from %s to %s for %s (%s).',field_address,oldValue,num2str(newValue),Component.matlabId,class(Component));
else
    

%Update Log
obj.addtolog('Changed %s from %s to %s for %s (%s).',description,oldValue,num2str(newValue),Component.matlabId,class(Component));
end
end



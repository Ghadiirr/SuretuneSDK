function [  ] = SDK_updatexml(obj,Component,field_address,value)
%SDK_UPDATEXML Summary of this function goes here
%   Detailed explanation goes here
Component_address = Component.path;
address = [Component_address,field_address];

evalthis = [address,' = ''',num2str(value),''';'];
eval(evalthis);


end



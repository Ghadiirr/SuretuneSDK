function [ boolean ] = SDK_isregisterable( inputArgument )
%SDK_ISREGISTERABLE Summary of this function goes here
%   Detailed explanation goes here

supercl = superclasses(inputArgument);
boolean = any(ismember(supercl,'SessionComponent'));


end


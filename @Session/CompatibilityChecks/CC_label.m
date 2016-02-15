function [ output ] = CC_label( obj,label )
%CC_LABEL Summary of this function goes here
%   Detailed explanation goes here

S = obj.session;

if isempty(label)
    label = 'NoLabel';
end

if ~ischar(label)
    error('Label has to be a string')
end


output = label;



end


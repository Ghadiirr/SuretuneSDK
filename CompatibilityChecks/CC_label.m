function [ output ] = CC_label( obj,label )
%CC_LABEL Summary of this function goes here
%   Detailed explanation goes here



if isempty(label)
    label = 'NoLabel';
end

if ~ischar(label)
    error('Label has to be a string')
end


label = strrep(label,'(','');
label = strrep(label,')','');
label = strrep(label,':','');
label = strrep(label,' ','_');
output = label;



end


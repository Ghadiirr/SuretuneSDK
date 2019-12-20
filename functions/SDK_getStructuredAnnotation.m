function [ StructAnnotation ] = SDK_getStructuredAnnotation( xml )
%SDK_GETSTRUCTUREDANNOTATION Summary of this function goes here
%   Detailed explanation goes here


if isfield(xml,'structuredAnnotations')
    if isfield(xml.structuredAnnotations.Array,'StimPlanStructuredAnnotation')
    for iAnnotation = 1:numel(xml.structuredAnnotations.Array.StimPlanStructuredAnnotation)
        thisAnnotation = xml.structuredAnnotations.Array.StimPlanStructuredAnnotation{iAnnotation};
        StructAnnotation.(thisAnnotation.tagName.Attributes.value) = thisAnnotation.value.Attributes.value;
    end
    end
        
end

if ~exist('StructAnnotation', 'var')
    StructAnnotation = [];
end

end


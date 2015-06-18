classdef ImageBasedStructureSegmentation < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        opacity
        color
        threshold
        thresholdType
        blurEnabled
        boundingBox
        includeSeeds
        excludeSeeds
    end
    
    methods
        function obj = ImageBasedStructureSegmentation(component_args,registerable_args,label, opacity, color, threshold, thresholdType, blurEnabled,boundingBox, includeSeeds, excludeSeeds)
            
            %inherit superclass properties from SessionComponent and
            %Registerable classes.
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.label = label;
            obj.opacity = opacity;
            obj.color = color;
            obj.threshold = threshold;
            obj.thresholdType = thresholdType;
            obj.blurEnabled = blurEnabled;
            obj.boundingBox = boundingBox;
            obj.includeSeeds = includeSeeds;
            obj.excludeSeeds = excludeSeeds;
            %             obj.registerable = registerable;
        end
    end
    
end


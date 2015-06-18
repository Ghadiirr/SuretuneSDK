classdef ManualStructureSegmentation < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        opacity
        color
        contourStacks
    end
    
    methods
        function obj = ManualStructureSegmentation(component_args, registerable_args,label,opacity,color,contourStacks);
            
            %inherit superclass properties from SessionComponent and
            %Registerable classes.
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.label = label;
            obj.opacity = opacity;
            obj.color = color;
            obj.contourStacks = contourStacks;
            
        end
    end
    
end


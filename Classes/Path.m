classdef Path < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        target
        entry
        opacity
        marginRadius
        beyondTargetDistance        
    end
    
    methods
        function obj = Path(component_args, registerable_args,label,target,entry,opacity,marginRadius,beyondTargetDistance)
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.label= label;
            obj.target = target;
            obj.entry = entry;
            obj.opacity = opacity;
            obj.marginRadius = marginRadius;
            obj.beyondTargetDistance = beyondTargetDistance;
        end
    end
    
end


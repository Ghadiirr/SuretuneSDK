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
        
        
        function obj = set.label(obj,label)
            S = obj.session;
            if ~S.updateXml;obj.label = label;return;end
            
            %Check compatibility with STU
            label = obj.CC_label(label);
            
            %Update Object
            obj.label = label;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.label.Attributes.value',label,'label')
            
        end
    end
    
end


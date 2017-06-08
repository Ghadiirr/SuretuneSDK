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
%             label = obj.CC_label(label);
            
            %Update Object
            obj.label = label;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.label.Attributes.value',label,'label')
            
        end
        
        function obj = set.entry(obj,entry)
            S = obj.session;
            if ~S.updateXml;obj.entry = entry;return;end
            
            
            %Update Object
            obj.entry = entry;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.entry',SDK_vector2point3d(entry),'entry')
            
        end
                function obj = set.target(obj,target)
            S = obj.session;
            if ~S.updateXml;obj.target = target;return;end
            
            
            %Update Object
            obj.target = target;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.target',SDK_vector2point3d(target),'target')
            
        end
    end
    
end


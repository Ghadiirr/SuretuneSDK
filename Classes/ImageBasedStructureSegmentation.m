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
        
        function obj = set.label(obj,label)
            obj.label = label;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.label.Attributes.value',label,'Label');
        end
        
        function obj = set.opacity(obj,opacity)
            obj.opacity = opacity;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.opacity.Attributes.value',opacity,'opacity');
        end
        
        function obj = set.color(obj,color)
            obj.color = color;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.color.Attributes.value',color,'color');
        end
        
        function obj = set.threshold(obj,threshold)
            obj.threshold = threshold;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.threshold.Attributes.value',threshold,'threshold');
        end
        
        function obj = set.thresholdType(obj,thresholdType)
            obj.thresholdType = thresholdType;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.thresholdType.Enum.Attributes.value',thresholdType,'thresholdType');
        end
        
        function obj = set.blurEnabled(obj,blurEnabled)
            obj.blurEnabled = blurEnabled;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.blurEnabled.Attributes.value',blurEnabled,'blurEnabled');
        end
        
        function obj = set.boundingBox(obj,boundingBox)
            obj.boundingBox = boundingBox;
            warning('Bounding Box not yet supported')
%             %update the XML;
%             SDK_updatexml(obj.session,obj,'.meshId.Attributes.value',boundingBox,'boundingBox');
        end
        
        function obj = set.includeSeeds(obj,includeSeeds)
            obj.includeSeeds = includeSeeds;
            warning('IncludeSeeds not yet supported')
            %update the XML;
%             SDK_updatexml(obj.session,obj,'.meshId.Attributes.value',includeSeeds,'includeSeeds');
        end
        
        function obj = set.excludeSeeds(obj,excludeSeeds)
            obj.excludeSeeds = excludeSeeds;
            warning('ExcludeSeeds not yet supported')
            %update the XML;
%             SDK_updatexml(obj.session,obj,'.meshId.Attributes.value',excludeSeeds,'excludeSeeds');
        end
        
        
        
        
    end
    
end


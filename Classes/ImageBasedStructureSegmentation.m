classdef ImageBasedStructureSegmentation < SessionComponent & Registerable
    %ImageBasedStructureSegmentation is a class belonging to @Session
    %   this class is instantiated by Session.
    
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
%             warning('Bounding Box not yet supported')
%             %update the XML;
            if ~isstruct(boundingBox)
                warning('BoundingBox contains leftDown and/or rightUp')
            end
            if isfield(boundingBox,'leftDown')
                block = SDK_vector2point3d( boundingBox.leftDown );
                SDK_updatexml(obj.session,obj,'.boundingBox.BoundingBox.leftDown',block,'boundingBox leftDown');
            end
            if isfield(boundingBox,'rightUp')
                block = SDK_vector2point3d( boundingBox.rightUp );
                SDK_updatexml(obj.session,obj,'.boundingBox.BoundingBox.rightUp',block,'boundingBox rightUp');
              
            end

            
        end
        
        function obj = set.includeSeeds(obj,includeSeeds)
            obj.includeSeeds = includeSeeds;
            
            block = SDK_vector2point3d( includeSeeds );
            %update the XML
            SDK_updatexml(obj.session,obj,'.includeSeeds',block,'includeSeeds');

           
        end
        
        function obj = set.excludeSeeds(obj,excludeSeeds)
            obj.excludeSeeds = excludeSeeds;
            
            block = SDK_vector2point3d( excludeSeeds );
            %update the XML
            SDK_updatexml(obj.session,obj,'.excludeSeeds',block,'excludeSeeds');
        end
        
        function newObj = computeobj(obj)
            bb = obj.boundingBox;
            V = obj.parent.volume;
            cropped = V.getcroppedvolume(bb);
            [X,Y,Z] = cropped.getndgrid;
            Z = Z/10;
            
            threshold  = (str2double(obj.threshold) - str2double(cropped.volumeInfo.rescaleIntercept))*str2double(cropped.volumeInfo.rescaleSlope);
            

            FV = isosurface(X,Y,Z,smooth3(flip(cropped.voxelArray)),threshold);
            v = FV.vertices;
            v(:,3) = v(:,3)*10;
            newObj = Obj(v,FV.faces,'');

            
        end
        
        
        
        
    end
    
end


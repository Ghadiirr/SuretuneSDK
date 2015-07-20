classdef ImportedMeshPart < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        meshId
        color
        opacity
        obj
        ambientLightingLevel
        diffuseLightingLevel
        specularLightingLevel
    end
    
    methods
        function obj = ImportedMeshPart(component_args, registerable_args,meshId,color,opacity);
            
            %inherit superclass properties from SessionComponent and
            %Registerable classes.
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            %try to find its parent, and add itself as a part.
            p = obj.parent;
            p.addparts(obj);
            
            obj.meshId = meshId;
            obj.color = color;
            obj.opacity = opacity;
            
            obj.ambientLightingLevel = 0.2;
            obj.diffuseLightingLevel = 0.8;
            obj.specularLightingLevel = 0.6;
            
            
            
            
            %Try to find the obj file and add itself as a registerable:
            ind=find(ismember(obj.session.meshStorage.names,meshId));
            if ~isempty(ind)
                obj.session.meshStorage.list{ind(1)}.linktoregisterable(obj);
            end
            
            
            
            
            
            
        end
        
        function obj = set.meshId(obj,meshId)
            

            obj.meshId = meshId;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.meshId.Attributes.value',meshId,'MeshId');
            
        end
        
        
        
        function obj = set.color(obj,color)
            

            
            %change object
            obj.color = color;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.color.Color.Attributes.value',color,'Color');
            
        end
        
        
        function obj = set.opacity(obj,opacity)

            %change object
            obj.opacity = opacity;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.opacity.Attributes.value',opacity,'Opacity');
            
        end
        
        function obj = set.ambientLightingLevel(obj,ambient)
            

            %change object
            obj.ambientLightingLevel = ambient;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.ambientLightingLevel.Attributes.value',ambient,'ambientLightingLevel');
            
        end
        
        function obj = set.diffuseLightingLevel(obj,diffuse)
            
            %change object
            obj.diffuseLightingLevel = diffuse;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.diffuseLightingLevel.Attributes.value',diffuse,'diffuseLightingLevel');
            
        end
        
        function obj = set.specularLightingLevel(obj,specular)

            %change object
            obj.specularLightingLevel = specular;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.specularLightingLevel.Attributes.value',specular,'specularLightingLevel');
            
        end
        
        function obj = linktoobj(obj,objInstance)
            obj.obj = objInstance;
        end
    end
    
end


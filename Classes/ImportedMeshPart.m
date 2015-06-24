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
                obj.session.meshStorage.list{ind}.linktoregisterable(obj);
            end
            
            
            
            
            
            
        end
        
        function obj = set.meshId(obj,meshId)
            
            %-- get the Session.
            S = obj.session;
            
            %             if S.noLog;obj.meshId = meshId; return;end
            
            
            
            %change object
            obj.meshId = meshId;
            
            %update the XML;
            SDK_updatexml(S,obj,'.MeshId.Attributes.value',meshId);
            
        end
        
        
        
        function obj = set.color(obj,color)
            
            %-- get the Session.
            S = obj.session;
            
            %             if S.noLog;obj.color = color; return;end
            
            
            
            %change object
            obj.color = color;
            
            %update the XML;
            SDK_updatexml(S,obj,'.Color.Color.Attributes.value',color);
            
        end
        
        
        function obj = set.opacity(obj,opacity)
            
            %-- get the Session.
            S = obj.session;
            
            if S.noLog;obj.opacity = opacity; return;end
            
            
            
            %change object
            obj.opacity = opacity;
            
            %update the XML;
            SDK_updatexml(S,obj,'.Opacity.Attributes.value',opacity);
            
        end
        
        function obj = set.ambientLightingLevel(obj,ambient)
            
            %-- get the Session.
            S = obj.session;
            
            %             if S.noLog;obj.color = color; return;end
            
            
            
            %change object
            obj.ambientLightingLevel = ambient;
            
            %update the XML;
            SDK_updatexml(S,obj,'.AmbientLightingLevel.Attributes.value',ambient);
            
        end
        
        function obj = set.diffuseLightingLevel(obj,diffuse)
            
            %-- get the Session.
            S = obj.session;
            
            %             if S.noLog;obj.color = color; return;end
            
            
            
            %change object
            obj.diffuseLightingLevel = diffuse;
            
            %update the XML;
            SDK_updatexml(S,obj,'.DiffuseLightingLevel.Attributes.value',diffuse);
            
        end
        
        function obj = set.specularLightingLevel(obj,specular)
            
            %-- get the Session.
            S = obj.session;
            
            %             if S.noLog;obj.color = color; return;end
            
            
            
            %change object
            obj.specularLightingLevel = specular;
            
            %update the XML;
            SDK_updatexml(S,obj,'.SpecularLightingLevel.Attributes.value',specular);
            
        end
        
        function obj = linktoobj(obj,objInstance)
            obj.obj = objInstance;
        end
    end
    
end


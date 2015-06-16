classdef ImportedMeshPart < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        meshId
        color
        opacity
        obj
    end
    
    methods
        function obj = ImportedMeshPart(component_args, registerable_args,meshId,color,opacity);
            
            %inherit superclass properties from SessionComponent and
            %Registerable classes.
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            %try to find its parent, and add itself as a part.
            p = obj.parent;
            p.addParts(obj);
            
            obj.meshId = meshId;
            obj.color = color;
            obj.opacity = opacity;
            
            
            %Try to find the obj file and add itself as a registerable:
            ind=find(ismember(obj.session.Meshes.names,meshId));
            if ~isempty(ind)
                obj.session.Meshes.list{ind}.LinkToRegisterable(obj);
            end
            
            

            
            

        end
        
        function obj = set.meshId(obj,meshId)

            %-- get the Session.
            S = obj.session; 
            
%             if S.NoLog;obj.meshId = meshId; return;end
        

            
            %change object
            obj.meshId = meshId;
            
            %update the XML;
            SDK_updateXML(S,obj,'.meshId.Attributes.value',meshId);
            
        end
        
       
        
        function obj = set.color(obj,color)

            %-- get the Session.
            S = obj.session; 
            
%             if S.NoLog;obj.color = color; return;end
        

            
            %change object
            obj.color = color;
            
            %update the XML;
            SDK_updateXML(S,obj,'.color.Color.Attributes.value',color);
            
        end
        
        
                function obj = set.opacity(obj,opacity)

            %-- get the Session.
            S = obj.session; 
            
            if S.NoLog;obj.opacity = opacity; return;end
        

            
            %change object
            obj.opacity = opacity;
            
            %update the XML;
            SDK_updateXML(S,obj,'.opacity.Attributes.value',opacity);
            
                end
        
                function obj = linkToObj(obj,objInstance)
                    obj.obj = objInstance;
                end
    end
    
end


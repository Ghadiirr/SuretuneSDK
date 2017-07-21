classdef Atlas < SessionComponent & Registerable

    
    properties
        atlasId
        hemisphere
        group
        
    end
    
    methods
        function obj = Atlas(component_args, registerable_args,atlasId,hemisphere,group)
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args)
            
            obj.atlasId = atlasId;
            obj.hemisphere = hemisphere;
            obj.group = group;
        end
        
        
        
        function obj = set.atlasId(obj,atlasId)
            S = obj.session;
            if ~S.updateXml;obj.atlasId = atlasId;return;end
            
            
            %Update Object
            obj.atlasId = atlasId;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.Attributes.id',atlasId,'label')

        end
       
        
                function obj = set.hemisphere(obj,hemisphere)
            S = obj.session;
            if ~S.updateXml;obj.hemisphere = hemisphere;return;end
            
            
            %Update Object
            obj.hemisphere = hemisphere;
            
            if ~any([strcmp(hemisphere,'Left'),strcmp(hemisphere,'Right')])
                error('Hemisphere has to be ''Left'' or ''Right''.');
            end
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.hemisphere.Enum.Attributes.value',hemisphere,'hemisphere')

                end
        
                        
                function obj = set.group(obj,group)
            S = obj.session;
            if ~S.updateXml;obj.group = group;return;end
            
            
            %Update Object
            obj.group = group;
            
            if ~any([strcmp(group,'Stn'),strcmp(group,'GPi')])
                error('Hemisphere has to be ''Stn'' or ''GPi''.');
            end
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.atlasDefinition.AtlasDefinition.atlasGroup.Enum.Attributes.value',group,'group')

                end
        
       
        
    end
    
end


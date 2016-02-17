classdef Dataset < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        volumeId
        id
        stf
        volume
    end
    
    methods
        function obj = Dataset(component_args,registerable_args,label,volumeId,id,stf)
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args)
            
            obj.volumeId = volumeId;
            obj.label = label;
            obj.id = id;
            obj.stf = stf;
            
            
            %Check if a volume is indexed with the same volumeId
            
            index = find(ismember(obj.session.volumeStorage.names,volumeId));
            if ~isempty(index)
                if numel(index)>1;index = index(1);end
                obj.volume = obj.session.volumeStorage.list{index};
            end
            
        end
        
        
        
        function obj = set.label(obj,label)
            S = obj.session;
            if ~S.updateXml;obj.label = label;return;end
            
            %Check compatibility with STU
            label = CC_label(obj,label);
            
            %Update Object
            obj.label = label;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.label.Attributes.value',label,'label')
            
            
        end
        
        function obj = set.volumeId(obj,volumeId)
            S = obj.session;
            if ~S.updateXml;obj.volumeId = volumeId;return;end
            
            if ~ischar(volumeId)
                warning('volumeId should be a string')
            end
            
            if SDK_readabledialog(obj.session)
                
                %change object
                obj.volumeId = volumeId;
                SDK_updatexml(obj.session,obj,'.volumeId.Attributes.value',volumeId,'volumeId');
            end
            
        end
        
        function obj = set.id(obj,id)
            S = obj.session;
            if ~S.updateXml;obj.id = id;return;end
            
            %change object
            obj.id = id;
            
            
            SDK_updatexml(obj.session,obj,'.Attributes.id',id,'id for reference');
            
            
        end
        
        function obj = set.stf(obj,stf)
            S = obj.session;
            if ~S.updateXml;obj.stf = stf;return;end
            
            if strcmp(class(stf),'Stf')
                warning('stf has to be an Stf object. >> stfObject = Stf(accepted,transform,type,localizerPoints)')
            end
            
            
            %change object
            obj.stf = stf;
            warning('Updating STF in xml has not been implemented yet')
            
            
            
            
        end
        
        
        
        
        
        
    end
    
end


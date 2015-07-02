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
            %change object
            obj.label = label;
            
            

                SDK_updatexml(obj.session,obj,'.label.Attributes.value',label,'label');
                
            
        end
        
        function obj = set.volumeId(obj,VolumeId)

            %change object
            obj.volumeId = VolumeId;
            

                SDK_updatexml(obj.session,obj,'.volumeId.Attributes.value',VolumeId,'volumeId');
            
        end
        
        function obj = set.id(obj,id)

            
            %change object
            obj.id = id;
            

                SDK_updatexml(obj.session,obj,'.Attributes.id',id,'id for reference');
            
            
        end
        
        function obj = set.stf(obj,stf)

            
            %change object
            obj.stf = stf;
            warning('Dataset set stf has to be made')
           
            
            
            
            
        end
        
        
        
        
        
        
    end
    
end


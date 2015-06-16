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
            
            obj.label = label;
            obj.volumeId = volumeId;
            obj.id = id;
            obj.stf = stf;
            
            
            %Check if a volume is indexed with the same volumeId
            
            index = find(ismember(obj.session.Volumes.names,volumeId));
            if ~isempty(index)
                if numel(index)>1;index = index(1);end
                obj.volume = obj.session.Volumes.list{index};
            end
                
                
            

        end
        
        
        
        function obj = set.label(obj,label)
                        %-- get the Session.
          S = obj.session; 
          
            %change object
            obj.label = label;
            
            %update the XML;
            SDK_updateXML(S,obj,'.label.Attributes.value',label);
        end
        
        function obj = set.volumeId(obj,VolumeId)
                        %-- get the Session.
          S = obj.session; 
          
            %change object
            obj.volumeId = VolumeId;
            
            %update the XML;
            SDK_updateXML(S,obj,'.volumeId.Attributes.value',VolumeId);
        end        
        
       function obj = set.id(obj,id)
                        %-- get the Session.
          S = obj.session; 
          
            %change object
            obj.id = id;
            
            %update the XML;
            SDK_updateXML(S,obj,'.Attributes.id',id);
            

       end     
        
              function obj = set.stf(obj,stf)
                        %-- get the Session.
          S = obj.session; 
          
            %change object
            obj.stf = stf;
            
    
            

        end  
       
        
        
        
        
        
    end
    
end


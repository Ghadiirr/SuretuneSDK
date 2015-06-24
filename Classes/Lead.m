classdef Lead < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        leadType
        distal
        proximal
        stimPlan
        label
    end
    
    methods
        function obj = Lead(component_args,registerable_args,distal,proximal,stimPlan, leadType,label)
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.leadType = leadType;
            obj.proximal = proximal;
            obj.distal = distal;
            obj.stimPlan = {};
            obj.label = label;
        end
        
        
        
    end
    
    
    methods
        function obj = set.leadType(obj,leadType)
            if obj.noSet;obj.leadType = leadType; return;end
            
            if not(ischar(leadType));error('Lead type has to be a string');end
            
            possible_leadTypes = {'Medtronic3389','Medtronic3387','None','BostonScientific','StJudeMedical6142_6145','StJudeMedical6146_6149','SapiensContactsShort','SapiensContactsLong','SapiensSegmentsLong'};  %we may need to add more leads here.
            if not(any(ismember(possible_leadTypes,leadType)));
                error(['Lead type (',leadType,') does not exist']);
            end
            
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            S.addtolog('Changed leadType from %s to %s for %s',obj.leadType,leadType, obj.matlabId);
            
            %change the value in the object
            obj.leadType = leadType;
            
            %update the XML
            SDK_updatexml(S,obj,'.leadType.Enum.Attributes.value',leadType);
            
            
        end
        
        function obj = set.label(obj,label)
            if obj.noSet;obj.label = label; return;end
            
            if not(ischar(label));error('label has to be a string');end
            
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            S.addtolog('Changed label from %s to %s for %s',obj.label,label, obj.matlabId);
            
            %change the value in the object
            obj.label = label;
            
            %update the XML
            SDK_updatexml(S,obj,'.label.Attributes.value',label);
            
            
        end
    end
    
end


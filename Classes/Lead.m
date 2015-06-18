classdef Lead < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        leadtype
        distal
        proximal
        stimplan
        label
    end
    
    methods
        function obj = Lead(component_args,registerable_args,distal,proximal,stimplan, leadtype,label)
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.leadtype = leadtype;
            obj.proximal = proximal;
            obj.distal = distal;
            obj.stimplan = {};
            obj.label = label;
        end
        
        
        
    end
    
    
    methods
        function obj = set.leadtype(obj,leadtype)
            if obj.noset;obj.leadtype = leadtype; return;end
            
            if not(ischar(leadtype));error('leadtype has to be a string');end
            
            possible_leadtypes = {'Medtronic3389','Medtronic3387','None','BostonScientific','StJudeMedical6142_6145','StJudeMedical6146_6149','SapiensContactsShort','SapiensContactsLong','SapiensSegmentsLong'};  %we may need to add more leads here.
            if not(any(ismember(possible_leadtypes,leadtype)));
                error(['Leadtype (',leadtype,') does not exist']);
            end
            
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            S.log('Changed leadtype from %s to %s for %s',obj.leadtype,leadtype, obj.MATLABid);
            
            %change the value in the object
            obj.leadtype = leadtype;
            
            %update the XML
            SDK_updateXML(S,obj,'.leadType.Enum.Attributes.value',leadtype);
            
            
        end
        
        function obj = set.label(obj,label)
            if obj.noset;obj.label = label; return;end
            
            if not(ischar(label));error('label has to be a string');end
            
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            S.log('Changed label from %s to %s for %s',obj.label,label, obj.MATLABid);
            
            %change the value in the object
            obj.label = label;
            
            %update the XML
            SDK_updateXML(S,obj,'.label.Attributes.value',label);
            
            
        end
    end
    
end


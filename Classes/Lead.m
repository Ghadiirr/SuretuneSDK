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
            S = obj.session;
            if ~S.updateXml;obj.leadType = leadType; return;end
            
            if not(ischar(leadType));error('Lead type has to be a string');end
            
            possible_leadTypes = {'Medtronic3389','Medtronic3387','None','BostonScientific','StJudeMedical6142_6145','StJudeMedical6146_6149','SapiensContactsShort','SapiensContactsLong','SapiensSegmentsLong'};  %we may need to add more leads here.
            if not(any(ismember(possible_leadTypes,leadType)));
                error(['Lead type (',leadType,') does not exist']);
            end
            
            
            %change the value in the object
            obj.leadType = leadType;
            
            
            %write it in the log.
            
            
            %update the XML
            SDK_updatexml(S,obj,'.leadType.Enum.Attributes.value',leadType,'leadType');
            
            
        end
        
        function obj = set.label(obj,label)
            S = obj.session;
            if ~S.updateXml;obj.label = label;return;end
            
            %Check compatibility with STU
            %             label = obj.CC_label(label);
            
            %Update Object
            obj.label = label;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.label.Attributes.value',label,'label')
            
            
        end
        function obj = set.proximal(obj,proximal)
            S = obj.session;
            if ~S.updateXml;obj.proximal = proximal; return;end
            
            
            
            %change the value in the object
            obj.proximal = proximal;
            
            
            %write it in the log.
            
            
            %update the XML
            SDK_updatexml(S,obj,'.proximal',SDK_vector2point3d(proximal),'leadType');
            
            
        end
        
        function obj = set.distal(obj,distal)
            S = obj.session;
            if ~S.updateXml;obj.distal = distal; return;end
            
            
            
            %change the value in the object
            obj.distal = distal;
            
            
            %write it in the log.
            
            
            %update the XML
            SDK_updatexml(S,obj,'.distal',SDK_vector2point3d(distal),'leadType');
            
            
        end
        
        
        
    end
    
end


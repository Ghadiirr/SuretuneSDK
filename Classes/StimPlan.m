classdef StimPlan  < SessionComponent 
    %STIMPLAN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vta
        lead
        label
        voltageBasedStimulation
        stimulationValue
        pulseWidth
        pulseFrequency
        activeRings
        contactsGrounded
        annotation
        
    end
    
    
    methods
        function obj = StimPlan(component_args,VTA,Lead,label,voltageBasedStimulation,stimulationValue,pulseWidth,pulseFrequency,activeRings,contactsGrounded,annotation)
            obj@SessionComponent(component_args{:});

            
            obj.vta = VTA;
            obj.lead = Lead;
            obj.label = label;
            obj.voltageBasedStimulation = voltageBasedStimulation;
            obj.stimulationValue = stimulationValue;
            obj.pulseWidth = pulseWidth;
            obj.pulseFrequency = pulseFrequency;
            obj.activeRings = activeRings;
            obj.contactsGrounded = contactsGrounded;
            obj.annotation = annotation;
            
            obj.linktolead(Lead)
            
        end
        
        function linktolead(obj,leadObject)
            leadObject.stimPlan{end+1} = obj;
            
            %Also link to session
            obj.session.therapyPlanStorage{end+1} = obj;
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
        
    end
    
end


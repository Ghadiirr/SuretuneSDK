classdef StimPlan
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
    
   properties (Hidden=true)
        session
        
        
    end
    
    methods
        function obj = StimPlan(VTA,Lead,label,voltageBasedStimulation,stimulationValue,pulseWidth,pulseFrequency,activeRings,contactsGrounded,annotation)
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
            obj.session = leadObject.session;
            obj.session.therapyPlanStorage{end+1} = obj;
        end
        
    end
    
end


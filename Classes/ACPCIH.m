classdef ACPCIH < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ac
        pc
        ih
        
        
    end
    
    properties (Hidden = true)
%         noset
    end
    
    methods
        function obj = ACPCIH(component_args, registerable_args,ac,pc,ih)
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.noset = 1;
            obj.ac = ac;
            obj.pc = pc;
            obj.ih = ih;
            obj.noset = 0;
            
        end
        
        function obj = set.ac(obj,ac)
            if obj.noset;obj.ac = ac; return;end
            
            error('ACPCIH object has not been made yet')
            if not(ismatrix(ac));error('Input has to be a 3D vector');end
            if not(numel(ac)==3);error('Input has to be a 3D vector');end
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            S.log('Changed AC');
            
            %change the value in the object
            obj.accepted = newval;
            
            %update the XML
            SDK_updateXML(S,obj,'.accepted.Attributes.value',newval);
            
            
        end
        
        
        function obj = set.pc(obj,pc)
            if obj.noset;obj.pc = pc; return;end
            
            error('ACPCIH object has not been made yet')
        end
        
        function obj = set.ih(obj,ih)
            if obj.noset;obj.ih = ih; return;end
            
            error('ACPCIH object has not been made yet')
        end
    end
    
end


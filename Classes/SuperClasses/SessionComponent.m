classdef SessionComponent < handle
    %SESSIONCOMPONENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Hidden = true)
        path
        session
    end
    
    methods
        function obj = SessionComponent(path,session) %constructor
            obj.path = path;
            obj.session = session;
        end
        
        
        
        
    end
    
end


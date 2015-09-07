classdef Stf < handle
    %STF is a class belonging to @Session.
    %   
    
    properties
        accepted
        transform
        type
        localizerPoints
    end
    
    methods
        function obj = Stf(accepted,transform,type,localizerPoints)
            obj.accepted = accepted;
            
            
            M3D = transform.Matrix3D;
            T = SDK_matrix3d2transform(M3D);
            obj.transform = T;
            obj.type = type;
            obj.localizerPoints = localizerPoints;  %could be improved;
            
        end
    end
    
    
    methods
        
        
    end
    
end


classdef Stf < handle
    %STF Summary of this class goes here
    %   Detailed explanation goes here
    
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
            T = SDK_Matrix3D2T(M3D);
            obj.transform = T;
            obj.type = type;
            obj.localizerPoints = localizerPoints;  %could be improved;
            
        end
    end
    
    
    methods 

            
    end
    
end


classdef MerAnnotation < SessionComponent & Registerable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        merTable
        orientationReference
        radius
    end
    
    methods
        function  obj = MerAnnotation(component_args,registerable_args,merTable,orientationReference,radius);
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.merTable = merTable;
            obj.orientationReference = orientationReference;
            obj.radius = radius;         
            
        end
        
        function obj = set.merTable(obj,merTable)
            S = obj.session;
            
            if ischar(merTable)
                ind = ismember(S.merTableStorage.names,merTable);
                obj.merTable = S.merTableStorage.list{ind};
            end
                
            
        end
       
    end
    
end


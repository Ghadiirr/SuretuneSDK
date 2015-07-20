classdef Obj <handle
    %OBJFILE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileName
        v
        f
    end
    
    properties (Hidden=true)
        session
        registerable
        
    end
    
    methods
        function obj = Obj(V,F,FileName)
            obj.fileName = FileName;
            obj.v = V;
            obj.f = F;
        end
        
        function obj = linktosession(obj,Session)
            obj.session = Session;
            Session.meshStorage.list{end+1} = obj;
            Session.meshStorage.names{end+1} = obj.fileName;
        end
        
        function savetofolder(obj,folder)
            vertface2obj(obj.v,obj.f,[folder,'/',obj.fileName]);
        end
        
        function linktoregisterable(obj,R)
            obj.registerable{end+1} = R;
            R.linktoobj(obj);
        end
        
        
        
    end
    
end


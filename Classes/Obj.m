classdef Obj <handle
    %OBJFILE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FileName
        V
        F
    end
    
    properties (Hidden=true)
        Session
        Registerable
        
    end
    
    methods
        function obj = Obj(V,F,FileName)
            obj.FileName = FileName;
            obj.V = V;
            obj.F = F;
        end
        
        function obj = LinkToSession(obj,Session)
            obj.Session = Session;
            Session.Meshes.list{end+1} = obj;
            Session.Meshes.names{end+1} = obj.FileName;
        end
        
        function saveToFolder(obj,folder)
            vertface2obj(obj.V,obj.F,[folder,'/',obj.FileName])
        end
        
        function LinkToRegisterable(obj,R)
            obj.Registerable{end+1} = R;
            R.linkToObj(obj);
        end
            
            
        
    end
    
end


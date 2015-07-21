classdef Obj < handle
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
            if nargin~=3
                obj.fileName = [];
                obj.v = [];
                obj.f = [];
            else
                
                obj.fileName = FileName;
                obj.v = V;
                obj.f = F;
            end
        end
        
        function obj = set.v(obj,v)
            if size(v,2)~=3
                error('vertex list needs to have 3 columns')
            end
            obj.v = v;
        end
        
        function obj = set.f(obj,f)
            
            obj.f = f;
        end
        
        function TR = triangulate(obj)
            TR = triangulation(obj.v,obj.f);
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
            warning('Unfinished function')
            obj.registerable{end+1} = R;
            R.linktoobj(obj);
        end
        
        
        
    end
    
end


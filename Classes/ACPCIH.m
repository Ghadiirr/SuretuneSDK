classdef ACPCIH < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ac
        pc
        ih
        
        
    end
    
    properties (Hidden = true)
        %         noSet
    end
    
    methods
        function obj = ACPCIH(component_args, registerable_args,ac,pc,ih)
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            

            obj.ac = ac;
            obj.pc = pc;
            obj.ih = ih;
            
            
            
        end
        
        function obj = set.ac(obj,ac)
            if ~obj.session.updateXml;obj.ac = ac; return;end
            

            if ~(ismatrix(ac));error('Input has to be a 3D vector');end
            if ~(numel(ac)==3);error('Input has to be a 3D vector');end
            
 warning('ACPCIH object has not been made yet')
            
%             %-- get the Session.
%             S = obj.session;
%             
%             %change the value in the object
%             obj.ac = ac;
%             
%             %update the XML
%             SDK_updatexml(S,obj,'.accepted.Attributes.value',newval,'AC');
            
            
        end
        
        
        function obj = set.pc(obj,pc)
            obj.pc = pc; 
            
            warning('ACPCIH object has not been made yet')
        end
        
        function obj = set.ih(obj,ih)
            obj.ih = ih;
            
            warning('ACPCIH object has not been made yet')
        end
        
        function acpcihSpace = makeCoordinateSystem(obj)
            
            z = SDK_unitvector(obj.ih);
            y = SDK_unitvector(obj.pc-obj.ac);
            x = SDK_unitvector(cross(y,z));
            
            origin = (obj.pc+obj.ac)./2;
            
            transform = [x(1),y(1),z(1),origin(1);...
                x(2),y(2),z(2),origin(2);...
                x(3),y(3),z(3),origin(3);...
                0,0,0,1]'
            
            S = obj.session;
            S.addnewmesh('acpcCoordinateSystem',0,'Dataset0',transform)
            
            
            
            
            
            
            
        end
    end
    
end


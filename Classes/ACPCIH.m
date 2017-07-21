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
        label = 'ACPCIH';
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
            S = obj.session;
            if ~S.updateXml;obj.ac = ac;return;end
            
            %Check compatibility with STU
            [ac,Point3D] = CC_vector(obj,ac);
            
            %Update Object
            obj.ac = ac;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.ac',Point3D,'Anterior Commisure')
            
            
        end
        
        
        function obj = set.pc(obj,pc)
            S = obj.session;
            if ~S.updateXml;obj.pc = pc;return;end
            
            %Check compatibility with STU
            [pc,Point3D] = CC_vector(obj,pc);
            
            %Update Object
            obj.pc = pc;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.pc',Point3D,'Posterior Commisure')
        end
        
        function obj = set.ih(obj,ih)
            S = obj.session;
            if ~S.updateXml;obj.ih = ih;return;end
            
            %Check compatibility with STU
            [ih,Point3D] = CC_vector(obj,ih);
            
            %Update Object
            obj.ih = ih;
            
            %Update XML
            SDK_updatexml(obj.session,obj,'.ih',Point3D,'Inter Hemispheral Plane')
        end
        
        function acpcihSpace = makeCoordinateSystem(obj)
            
            z = SDK_unitvector(obj.ih);
            y = SDK_unitvector(obj.pc-obj.ac);
            x = SDK_unitvector(cross(y,z));
            
            origin = (obj.pc+obj.ac)./2;
            
            transform = [x(1),y(1),z(1),origin(1);...
                x(2),y(2),z(2),origin(2);...
                x(3),y(3),z(3),origin(3);...
                0,0,0,1]';
            
            S = obj.session;
            S.addnewmesh('acpcCoordinateSystem',0,'Dataset0',transform)
            
            
            
            
            
            
            
        end
    end
    
end


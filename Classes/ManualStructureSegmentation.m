classdef ManualStructureSegmentation < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        opacity
        color
        contourStacks
    end
    
    methods
        function obj = ManualStructureSegmentation(component_args, registerable_args,label,opacity,color,contourStacks);
            
            %inherit superclass properties from SessionComponent and
            %Registerable classes.
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.label = label;
            obj.opacity = opacity;
            obj.color = color;
            obj.contourStacks = obj.findcontours(contourStacks);
            
            
            
        end
        
        
        function contours = findcontours(obj,contourStacks)
            
            for kvindex = 1:numel(contourStacks.kv)
                ViewerDirection = contourStacks.kv{kvindex}.Enum.Attributes.value;
                contours.(ViewerDirection) = {};
                if ~isfield(contourStacks.kv{kvindex}.ContourStack.slicesToContours.HashTable,'kv');continue;end
                if iscell(contourStacks.kv{kvindex}.ContourStack.slicesToContours.HashTable.kv)
                    for kv2index = 1:numel(contourStacks.kv{kvindex}.ContourStack.slicesToContours.HashTable.kv)
                        if isfield(contourStacks.kv{kvindex}.ContourStack.slicesToContours.HashTable.kv{kv2index}.Array,'Point3D')
                            contours.(ViewerDirection){kv2index} = SDK_point3d2vector(contourStacks.kv{kvindex}.ContourStack.slicesToContours.HashTable.kv{kv2index}.Array.Point3D);
                        end
                    end
                else
                    if isfield(contourStacks.kv{kvindex}.ContourStack.slicesToContours.HashTable.kv.Array,'Point3D')
                        contours.(ViewerDirection) = SDK_point3d2vector(contourStacks.kv{kvindex}.ContourStack.slicesToContours.HashTable.kv.Array.Point3D);
                    end
                end
                
            end
        end
        
        function contours = getallcontours(obj)
            contours = {};
            for viewDirection = {'Axial','Coronal','Sagittal'}
                thisDirection  = obj.contourStacks.(viewDirection{1});
                if numel(thisDirection) == 0;
                    continue
                end
                if ~iscell(thisDirection{1})
                    contours{end+1} = thisDirection;
                else
                    contours = [contours,thisDirection];
                end
            end
        end
        
        function OBJ = getmesh(obj)
            session = obj.session;
            %             index = find(ismember(session.meshStorage.names,[obj.label,'.obj']));
            OBJ = session.meshStorage.list{ismember(session.meshStorage.names,[obj.label,'.obj'])};
            
        end
        
        function allcoordinates = computemesh(obj)
            session = obj.session;
            contours = obj.getallcontours;
            allpoints = horzcat(contours{:});
            vertices = vertcat(allpoints{:});
            mesh = Obj(vertices,convhull(vertices),'temp');
            mesh.subdividesurface(0.1,2000)
            
        end
    end
    
end



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
                warning('vertex list needs to have 3 columns')
            end
            obj.v = v;
        end
        
        function obj = set.f(obj,f)
            
            obj.f = f;
        end
        
        
        
        
        
        function obj = linktosession(obj,Session)
            obj.session = Session;
            Session.meshStorage.list{end+1} = obj;
            Session.meshStorage.names{end+1} = obj.fileName;
        end
        
        function savetofolder(obj,folder)
            [~,~] = mkdir(folder);
            vertface2obj(obj.v,obj.f,fullfile(folder,obj.fileName));
        end
        
        function linktoregisterable(obj,R)
            warning('Unfinished function')
            obj.registerable{end+1} = R;
            R.linktoobj(obj);
        end
        
        function handle = patch(obj,varargin)
            if numel(varargin)==0
                
                varargin{1} = 'FaceColor'; varargin{2} = 'r';
                
            end
            handle = patch('Vertices', obj.v, 'Faces', obj.f,varargin{:} );
            axis vis3d equal
            view([1 0 0])
            camlight('headlight')
            view([-1 0 0])
            camlight('right')
            view([0 0 -1])
            camlight('right')
            lighting phong
            rotate3d
            
            %             hold on
            %             triangles = obj.gettriangulation;
            %             P = incenter(triangles);
            %             fn = faceNormal(triangles);
            %             vn = vertexNormal(triangles);
            %             P2 = triangles.Points;
            %             quiver3(P(:,1),P(:,2),P(:,3), ...
            %             fn(:,1),fn(:,2),fn(:,3),0.5, 'color','k');
            %
            %                     quiver3(P2(:,1),P2(:,2),P2(:,3), ...
            %             vn(:,1),vn(:,2),vn(:,3),0.5, 'color','r');
            
            
        end
        
        function centerOfGravity = computecenterofgravity(obj,precision)
            if ~exist('VOXELISE.m')
                error('VOXELISE.m cannot be found. Make sure to add the Mesh_Voxelisation toolbox to your path')
            end
            
            % Define a boundingBox
            leftDown = min(obj.v);
            rightUp = max(obj.v);
            
            % Define voxels according to precision
            gridX = leftDown(1):precision:rightUp(1);
            gridY = leftDown(2):precision:rightUp(2);
            gridZ = leftDown(3):precision:rightUp(3);
            
            %Voxelise
            fv.faces = obj.f;
            fv.vertices = obj.v;
            disp('voxelising mesh...')
            gridOUTPUT = VOXELISE(gridX,gridY,gridZ,fv,'xyz');
            
            %get voxelcoordinates inside mesh
            disp('finding center of gravity...')
            [idx] = find(gridOUTPUT==1);
            [x,y,z] = ind2sub([numel(gridX),numel(gridY),numel(gridZ)],idx);
            
            centerOfGravityVoxel = [mean(x),mean(y),mean(z)];
            centerOfGravity = round(centerOfGravityVoxel+leftDown/precision)*precision;
            disp('done.')
            
        end
        
        function TR = gettriangulation(obj)
            
            TR = triangulation(obj.f,obj.v);
            
            
        end
        
        function subdividesurface(obj,maxmaxedge,maxnumvertices,buldge)
            [v,f] = SDK_subdividesurface(obj,maxmaxedge,maxnumvertices,8,buldge);
            %             [v,f] = SDK_smoothedges(obj,p1,p2,8,0.7);
            obj.v= v;
            obj.f = f;
            patch(obj)
        end
        
        function simultaneoussubdividesurface(obj,maxmaxedge,maxnumvertices,buldge)
            [v,f] = SDK_simultaneoussubdividesurface(obj,maxmaxedge,maxnumvertices,8,buldge);
            %             [v,f] = SDK_smoothedges(obj,p1,p2,8,0.7);
            obj.v= v;
            obj.f = f;
            patch(obj)
        end
        
        function simultaneoussubdividesurface_angle(obj,maxmaxedge,maxnumvertices,buldge)
            [v,f] = SDK_simultaneoussubdividesurface_angle(obj,maxmaxedge,maxnumvertices,8,buldge);
            %             [v,f] = SDK_smoothedges(obj,p1,p2,8,0.7);
            obj.v= v;
            obj.f = f;
            patch(obj)
        end
        
        function strains = getvertexstrains(obj)
            triangles = gettriangulation(obj);
            vertexnormals = triangles.vertexNormal;
            facenormals = triangles.faceNormal;
            strains = zeros(size(triangles.Points,1),1);
            vertexcoordinates = triangles.Points;
            connectivitylist = triangles.ConnectivityList;
            for iVertex = 1:size(triangles.Points,1)
                attachments = triangles.vertexAttachments{iVertex};
                thisVertex = vertexcoordinates(iVertex,:);
                thisVertexNormal = vertexnormals(iVertex,:);
                
                
                
                totalsum = 0;
                totalweight = 0;
                
                
                for iAttachment = 1:numel(attachments)
                    % get the normal
                    attachmentNormal = facenormals(iAttachment,:);
                    
                    
                    % get the angle between the normals
                    angle = atan2(norm(cross(attachmentNormal,thisVertexNormal)), dot(attachmentNormal,thisVertexNormal));
                    angle = abs(dot(attachmentNormal,thisVertexNormal)/(norm(attachmentNormal)*norm(thisVertexNormal)));
                    
                    %get the vertices on the face
                    vertices = connectivitylist(iAttachment,:);
                    vertices = setdiff(vertices,iVertex);
                    
                    edge1 = vertexcoordinates(vertices(1),:) - thisVertex;
                    edge2 = vertexcoordinates(vertices(2),:) - thisVertex;
                    
                    %weight
                    weight = atan2(norm(cross(edge1,edge2)), dot(edge1,edge2));  %difference is weighted according to angle at vertex
                    weight = dot(edge1,edge2)/(norm(edge1)*norm(edge2));
                    
                    %update sum
                    totalsum = totalsum+(angle*weight);
                    totalweight = totalweight+weight;
                    
                end
                
                strains(iVertex) = totalsum;%/totalweight;
                if isnan(totalsum/totalweight);
                    strains(iVertex) = 0;
                end
                
            end
        end
        
        
        
        
        
        
    end
    
end


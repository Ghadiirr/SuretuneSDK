function  [v,f] = smoothedges(obj,maxMaxEdgeLength,maxVertices,maxConnections,buldgeFactor)
warning('off','all')
%nested functions:
    function edgeLengthHeap = computeEdgeLengths()
        edges = triangles.edges;
        edgeLengthHeap = zeros(size(edges,1),1);
        vertices = triangles.Points;
        for iEdge = 1:size(edges,1)
            thisEdge= edges(iEdge,:);
            vertex1 = vertices(thisEdge(1),:);
            vertex2 = vertices(thisEdge(2),:);
            edgelength = norm(vertex1-vertex2);
            edgeLengthHeap(iEdge) = edgelength;
        end
    end

    function ComputeMaxEdgeLength(edgeLengthHeap)
        [maxLength,idx]= max(edgeLengthHeap);
        maxLengthEdge = idx(1);
    end

    function [maxAngle,maxAngleVertex,maxAngleFace] = ComputeMaxAngle(maxAngleHeap)
        [maxAngle,idx]= max(maxAngleHeap);
        maxAngleVertex = idx(1);
        
        vertexNormal = triangles.vertexNormal(maxAngleVertex);
        connectedFaces = triangles.vertexAttachments(maxAngleVertex);
        
        highestangle = 0;
        for iFace = 1:numel(connectedFaces{1})
            faceNormal = triangles.faceNormal(iFace);
            angle = computeanglebetweenvectors(faceNormal,vertexNormal);
            if angle > highestangle
                maxAngleFace = iFace;
                continue
            end
        end
        
        if ~exist('maxAngleFace');
            disp('sdf')
        end

    end

    function [edge,edgeInfo] = longestedgeonface(faceIdx)
        vertices = triangles.ConnectivityList(faceIdx,:);
        v1 = triangles.Points(vertices(1),:);
        v2 = triangles.Points(vertices(2),:);
        v3 = triangles.Points(vertices(3),:);
        
        d12 = norm(v1-v2);
        d23 = norm(v2-v3);
        d31 = norm(v3-v1);
        
        if d12 > d23 && d12 > d31
            edgeInfo = sort([vertices(1),vertices(2)]);
        elseif d23 > d12 && d23 > d31
            edgeInfo = sort([vertices(2),vertices(3)]);
        elseif d31 > d12 && d31 > d23
            edgeInfo = sort([vertices(3),vertices(1)]);
        else
            error('edge does not exist?')
        end
        e = triangles.edges;
        edge = find(all([e(:,1)==edgeInfo(1),e(:,2)==edgeInfo(2)]')==1);
    end
        
        
       

    function [connectedTriangles,connectedTrianglesIdx] = getConnectedTrianglesToEdge(edge)
        connectedTrianglesIdx = triangles.edgeAttachments(edge);
        connectedTrianglesIdx = sort(connectedTrianglesIdx{1},'descend');
        for triangleIdx = 1:numel(connectedTrianglesIdx)
            connectedTriangles{triangleIdx} = triangles.ConnectivityList(connectedTrianglesIdx(triangleIdx),:);
        end
        
    end


    function removeTriangle(idx)
        backupPoints = triangles.Points;
        backupConnectivityList = triangles.ConnectivityList;
        backupConnectivityList(idx,:) = []; %remove idx
        triangles = triangulation(backupConnectivityList,backupPoints);
    end

    function newPointIdx = addPoint(point)
        backupPoints = triangles.Points;
        backupConnectivityList = triangles.ConnectivityList;
        backupPoints(end+1,:) = point;
        newPointIdx = size(backupPoints,1);
        triangles = triangulation(backupConnectivityList,backupPoints);
    end

    function newTriangleIdx = addTriangle(newTriangle)
        backupPoints = triangles.Points;
        backupConnectivityList = triangles.ConnectivityList;
        backupConnectivityList(end+1,:) = newTriangle;
        newTriangleIdx = size(backupConnectivityList,1);
        triangles = triangulation(backupConnectivityList,backupPoints);
        
    end

    function neighbours = neighbourPoints(pointIdx)
        edges = triangles.edges;
        [edgenum,column] = find(edges==pointIdx);
        column(column==1) = 3;
        column(column==2) = 1;
        column(column==3) = 2;
        indices = sub2ind(size(edges),edgenum,column);
        
        neighbours = edges(indices);
    end







    function newPointIdx = splitEdgeIntoTwo(thisEdge)
        edges = triangles.edges;
        edgeInfo = edges(thisEdge,:);
        
        %compute mean vertex
        vertex1 = triangles.Points(edgeInfo(1),:);
        vertex2 = triangles.Points(edgeInfo(2),:);
        newpoint = mean([vertex1;vertex2]);
        newPointIdx = addPoint(newpoint);
        
        
        %get connected triangles
        [connectedTriangles,connectedTrianglesIdx] = getConnectedTrianglesToEdge(edgeInfo); %returns: connectedTriangles and connectedTrianglesIdx
        
        %splitTwotriangles in half
        for iTriangle = 1:numel(connectedTrianglesIdx)
            idxTriangle = connectedTrianglesIdx(iTriangle);
            removeTriangle(idxTriangle)
            oldTriangle = connectedTriangles{iTriangle};
            
            %Split old triangle in triangleA and triangleB
            triangleA = oldTriangle;
            triangleA(triangleA==edgeInfo(1)) = newPointIdx;
            addTriangle(triangleA);
            
            
            triangleB = oldTriangle;
            triangleB(triangleB==edgeInfo(2)) = newPointIdx;
            addTriangle(triangleB);
            
        end
    end

    function normalbasedsmoothing(newPointIdx,neighbours,buldgeFactor)
        edges = triangles.edges;
 
        quadmiddle = triangles.Points(newPointIdx,:);
        
        d1 = 0.5*((triangles.Points(neighbours(1),:) - triangles.Points(neighbours(2),:))*triangles.vertexNormal(neighbours(1))');
        d2 = 0.5*((triangles.Points(neighbours(2),:) - triangles.Points(neighbours(1),:))*triangles.vertexNormal(neighbours(2))');
        
        E = quadmiddle+buldgeFactor*(d1*triangles.vertexNormal(neighbours(1))+d2*triangles.vertexNormal(neighbours(2)))/2;

        
        %apply modification
        backupPoints = triangles.Points;
        backupConnectivityList = triangles.ConnectivityList;
        backupPoints(newPointIdx,:) = E;%quadmiddle+buldgeFactor*displacementsum;
        triangles = triangulation(backupConnectivityList,backupPoints);
        
        
        
    end

    function goodcandidate = isgoodcandidate(thisEdge,maxConnections)
        edges = triangles.edges;
        edgeInfo = edges(thisEdge,:);
        
        
        %get connected triangles
        [connectedTriangles,~] = getConnectedTrianglesToEdge(edgeInfo);
        involvedvertices = setdiff(unique(horzcat(connectedTriangles{:})),edgeInfo);
        connectedness = cellfun(@numel,triangles.vertexAttachments(involvedvertices'));
        goodcandidate = not(any(connectedness<maxConnections));

    end



    function angle = computeanglebetweenvectors(v1,v2)
        a = SDK_unitvector(v1);
        b = SDK_unitvector(v2);
        angle = atan2(norm(cross(a,b)), dot(a,b));
    end

    function vertexAngleHeap = computevertexangleheap()
        
        vertexnormals = triangles.vertexNormal;
        facenormals = triangles.faceNormal;
        
        for iVertex = 1:size(triangles.Points,1)
            connectedFaces = triangles.vertexAttachments(iVertex);
            anglesWithVertexNormal = 0;
            for iConnectedFaces = 1:numel(connectedFaces{1})
                connectedNormal = triangles.faceNormal(connectedFaces{1}(iConnectedFaces));
                anglesWithVertexNormal(iVertex) = computeanglebetweenvectors(connectedNormal,vertexnormals(iVertex,:));
            end
            try
            vertexAngleHeap(iVertex) = max(anglesWithVertexNormal);
            catch
                disp('sdfsd')
            end
        end
             
    end
    
    
    









triangles = obj.gettriangulation;
% edges = triangles.edges;
vertexAngleHeap = computevertexangleheap();
prevAngle = Inf;
h = waitbar(0);
while  size(triangles.Points,1)<=maxVertices
    waitbar(size(triangles.Points,1)/maxVertices)
    
    vertexAngleHeap = computevertexangleheap();
    [maxAngle,maxAngleVertex,maxAngleFace] = ComputeMaxAngle(vertexAngleHeap); %returns: maxLength and maxLengthEdge
    
    [edge,edgeInfo] = longestedgeonface(maxAngleFace);
    
  
       
    
    %split edge into two
    newPointIdx = splitEdgeIntoTwo(edge);
    
    %move new point
    normalbasedsmoothing(newPointIdx,edgeInfo,buldgeFactor)
    
    
    
    
end
close(h)
f = triangles.ConnectivityList;
v = triangles.Points;
end

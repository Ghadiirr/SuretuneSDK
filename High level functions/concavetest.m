function faces = concavetest(inputpoints,inputfaces)
%
    function maxLengthEdge = computelongestedge(nonBreakable,varargin)
        
        if nargin==2
            if strcmp(varargin{1},'cartesian')
                
                cartesiancheck = ones(size(nonBreakable));
                for iEdge = 1:size(edges,1)
                    if numel(unique([triangles.Points(edges(iEdge,1),:),triangles.Points(edges(iEdge,2),:)])) == 6
                        cartesiancheck(iEdge)=0;
                    end
                end
                
                
            end
            
        else
            cartesiancheck = ones(size(nonBreakable,1),1);
        end
        
        
        booleans = nonBreakable>0.5;
        cartesiancheckbool = cartesiancheck>0.5;
        edgePool = edgelengths;
        edgePool(booleans) = 0;
        edgePool(~cartesiancheckbool) = 0;
        
        
        maxLengthEdge = find(edgePool==max(edgePool));
        if numel(maxLengthEdge>1)
            maxLengthEdge = maxLengthEdge(1);
        end
    end

    function lengths = computeedgelengths()
        lengths = [];
        for i = 1:size(edges,1)
            p1 = triangles.Points(edges(i,1),:);
            p2 = triangles.Points(edges(i,2),:);
            lengths(i) = norm(p1-p2);
        end
        
    end

    function midPoint = getMidPoint(id)
        midPoint = mean([triangles.Points(edges(id,1),:);triangles.Points(edges(id,2),:)]);
    end

    function breakEdge(thisEdge,newVertex)
        connectedTriangles = triangles.edgeAttachments(edges(thisEdge,:));
        
        v1 = edges(thisEdge,1);
        v2 = edges(thisEdge,2);
        
        try
        triangle1 = triangles.ConnectivityList(connectedTriangles{1}(1),:);
        triangle2 = triangles.ConnectivityList(connectedTriangles{1}(2),:);
        catch
            disp('sfd')
        end

        
        triangle1a = triangle1;
        triangle1b = triangle1;
        
        triangle2a = triangle2;
        triangle2b = triangle2;
        
        triangle1a(triangle1a==v1) = newVertex;
        triangle1b(triangle1b==v2) = newVertex;
        
        
        triangle2a(triangle2a==v1) = newVertex;
        triangle2b(triangle2b==v2) = newVertex;
        
        cList = triangles.ConnectivityList;
        
        cList(connectedTriangles{1}(1),:) = triangle1a;
        cList(connectedTriangles{1}(2),:) = triangle2a;
        cList(end+1,:) = triangle1b;
        cList(end+1,:) = triangle2b;
        
        
        triangles = triangulation(cList,triangles.Points);
        
    end


triangles = triangulation(inputfaces,inputpoints);
edges = triangles.edges();
edgelengths = computeedgelengths();


iteration = 0;
nonBreakableEdges = zeros(size(edges,1),1);
while iteration < 10
    iteration = iteration+1;
    
    %find the longest edge
    maxLengthEdge = computelongestedge(nonBreakableEdges,'cartesian');
    
    if isnan(maxLengthEdge)
        maxLengthEdge = computelongestedge(nonBreakableEdges);
    end
    
    
    %compute the midpoint
    midPoint = getMidPoint(maxLengthEdge);
    
    %find the nearest neighbour
    nnId = triangles.nearestNeighbor(midPoint);
    
    %test if nearest neighbour is not part of the edge.
    connectedtriangles = triangles.edgeAttachments(edges(maxLengthEdge,:));
    if any(triangles.ConnectivityList(connectedtriangles{1},:)==nnId)
        nonBreakableEdges(maxLengthEdge) = 1;
        continue
    end
    
    
    %break edge
    breakEdge(maxLengthEdge,nnId)
    
    edges = triangles.edges();
    edgelengths = computeedgelengths();
    
    
end






faces = triangles.ConnectivityList;





end


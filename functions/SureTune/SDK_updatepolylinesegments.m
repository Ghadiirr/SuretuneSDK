function PolyLine = SDK_UpdatePolylineSegments(controlPoints)

PolyLine = {};
bezierControls = {};
Segmentindices = [];

if numel(controlPoints) <3
    for t = 1:size(controlPoints,1) 
        PolyLine{end+1} = controlPoints{t};
        Segmentindices(end+1) = 0;
    end
else
    Size = numel(controlPoints);
    bezierControls{end+1} = SDK_computebeziercontrol(controlPoints{Size},controlPoints{1},controlPoints{2});
    for i = 2:Size-1
        bezierControls{end+1} = SDK_computebeziercontrol(controlPoints{i-1},controlPoints{i},controlPoints{i+1});
    end
    bezierControls{end+1} = SDK_computebeziercontrol(controlPoints{Size-1},controlPoints{Size},controlPoints{1});
    
    
    pointleft = [];
    pointright =[];
    leftcontrol = [];
    rightcontrol = [];
    
    PolyLine{end+1} = controlPoints{1};
    Segmentindices(end+1) = 1;
    
    segmentidx = 1;
    currentpolyoffset = 2;
    
    for i = 2:Size
         pointleft = controlPoints{i-1};
        pointright = controlPoints{i};
        leftcontrol = bezierControls{i-1};
        rightcontrol = bezierControls{i};
        newPolyLine = SDK_generatepolylinesegment(pointleft,leftcontrol.Right,rightcontrol.Left,pointright);
        PolyLine = [PolyLine,newPolyLine];
        
        for j  = currentpolyoffset:numel(PolyLine)
            Segmentindices(end+1) = segmentidx;
        end
        currentpolyoffset = numel(PolyLine)+1;
        segmentidx = segmentidx+1;
    end
    
    pointleft = controlPoints{Size};
    pointright = controlPoints{1};
    leftcontrol = bezierControls{Size};
    rightcontrol = bezierControls{1};
    newPolyLine = SDK_generatepolylinesegment(pointleft,leftcontrol.Right,rightcontrol.Left,pointright);
    PolyLine = [PolyLine,newPolyLine];
    for j = currentpolyoffset:numel(PolyLine)
        Segmentindices(end+1) = segmentidx;
    end
end

if numel(Segmentindices) ~= numel(PolyLine)
    error('Error on PolyBezierContour')
end
end

    
    
    
        
        
        
    
    

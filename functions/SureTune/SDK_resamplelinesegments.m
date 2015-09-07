function [yield] = SDK_resamplelinesegments(lineSegments,distance)

yield = {};

if numel(lineSegments) < 2
    yield = {};
    return
end

currentDistance = 0;
prevPoint = lineSegments{1};
yield{end+1} = prevPoint;
for i = 2:numel(lineSegments)
    nextPoint = lineSegments{i};
    oneStepDirection = SDK_unitvector(nextPoint-prevPoint);
    while true
        deltaDistance = distance - currentDistance;
        lineEndDistance = abs(norm(prevPoint-nextPoint));
        if (lineEndDistance<deltaDistance)
            % No more samples at this line segment
            currentDistance = currentDistance+lineEndDistance;
            break;
        end
        prevPoint = prevPoint+ oneStepDirection*deltaDistance;
        yield{end+1} = prevPoint;
        currentDistance = 0;
    end
    prevPoint = nextPoint;
end
end
        
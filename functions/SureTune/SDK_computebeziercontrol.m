function [bezierControls] = SDK_computebeziercontrol( left,point,right)
%SDK_COMPUTEBEZIERCONTROL Summary of this function goes here
%   Detailed explanation goes here

accuracy = 1e-3;
bulge = 0.45;

    
leftVector  = left-point;
rightVector = right-point;

leftUnitVector = SDK_unitvector(leftVector);
rightUnitVector = SDK_unitvector(rightVector);
crossVector = cross(leftUnitVector,rightUnitVector);

crossVectorLength = norm(crossVector);


if (accuracy < crossVectorLength)
    % Successive points are not co-linear
    % tangent can be computed from source data
    normalVector = leftUnitVector+rightUnitVector;
    tangent = cross(normalVector,crossVector);
    tangent = SDK_unitvector(tangent);
else
    % Successive points are co-linear, set tangent to line...
    tangent = leftUnitVector;
end
    
dotProductLeft = tangent*leftVector'*bulge;
dotProductRight = tangent*rightVector'*bulge;

leftControlVector = point+tangent*dotProductLeft;
rightControlVector = point+tangent*dotProductRight;

bezierControls.Left = leftControlVector;
bezierControls.Right = rightControlVector;

end



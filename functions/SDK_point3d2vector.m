function [ v ] = SDK_point3d2vector( Point3D )
%SDK_MATRIX3D2T Summary of this function goes here
%   Detailed explanation goes here
if iscell(Point3D)
    v = {};
    for i=1:numel(Point3D)
        P = Point3D{i}.Attributes;
        v{i} = [str2double(P.x),str2double(P.y),str2double(P.z)];
    end
else
    
    P = Point3D.Attributes;
    v = [str2double(P.x),str2double(P.y),str2double(P.z)];
end
end


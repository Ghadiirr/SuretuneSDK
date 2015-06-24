function [ v ] = SDK_point3d2vector( Point3D )
%SDK_MATRIX3D2T Summary of this function goes here
%   Detailed explanation goes here

    P = Point3D.Attributes;
    v = [str2double(P.x),str2double(P.y),str2double(P.z)];
end


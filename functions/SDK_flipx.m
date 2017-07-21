function [ v ] = SDK_flipx( v )
%SDK_FLIPX Summary of this function goes here
%   Detailed explanation goes here


%Mirror image data
v.voxelArray = flip(v.voxelArray,1);

%Mirror volumeInfo
x1 = v.volumeInfo.origin(1);
x2 = v.volumeInfo.spacing(1)*v.volumeInfo.dimensions(1);

v.volumeInfo.origin(1) = -x1-x2;







end


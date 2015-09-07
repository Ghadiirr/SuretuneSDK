function [ Block ] = SDK_vector2point3d( vector )
%SDK_MATRIX3D2T Summary of this function goes here
%   Detailed explanation goes here
if iscell(vector)
    Block.Array.Point3D={};
    for i=1:numel(vector)
        Block.Array.Point3D{i}.Attributes.x = vector{i}(1);
        Block.Array.Point3D{i}.Attributes.y = vector{i}(2);
        Block.Array.Point3D{i}.Attributes.z = vector{i}(3);
        
    end
elseif isempty(vector)
    Block = [];
else
    
    Block.Point3D.Attributes.x = vector(1);
    Block.Point3D.Attributes.y = vector(2);
    Block.Point3D.Attributes.z = vector(3);

end
end


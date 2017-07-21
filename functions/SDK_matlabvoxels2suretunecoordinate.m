function [ volumecoordinates ] = SDK_matlabvoxels2suretunecoordinate( voxelindex, V)


if not(numel(voxelindex)==3)
    return
end

if (size(voxelindex,1)==3)
    voxelindex = voxelindex';
end


%get volumeinfo
spacing = V.volume.volumeInfo.spacing;
origin = V.volume.volumeInfo.origin;
dimensions = V.volume.volumeInfo.dimensions;


%Go to LPS
LPSvoxels(1) = dimensions(1)-voxelindex(2)+1;
LPSvoxels(2) = voxelindex(1)-1;
LPSvoxels(3) = voxelindex(3)-1;


%convert to mm
coordinates = LPSvoxels.*spacing;

volumecoordinates = coordinates+origin;

end


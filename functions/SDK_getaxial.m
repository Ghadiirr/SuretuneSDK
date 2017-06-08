function [ V, Dim ] = SDK_getaxial( V, T,Dim )
%SDK_GETAXIAL Summary of this function goes here
%   Detailed explanation goes here

%init
XYZ = [1,2,3];


% extract rotation part
T = T(1:3,1:3);
Axial = [1 0 0;0 1 0;0 0 1];

%check if inverse or not axial.
inverse = sum(T,1)<0
notaxial = not(sum(Axial.*T))
% 
  
%Rotate 3D array by replacing XY, YZ or XZ    
if notaxial == [0 1 1]
        XYZ = [1 3 2];
        disp('transpose in sagittal plane (YZ)')
end
if notaxial == [1 1 0]
        XYZ = [2 1 3];
        disp('transpose in axial plane (XY)')
end
if notaxial == [1 0 1]
        XYZ = [3 2 1];
        disp('transpose in coronal plane (xz)')
end



%flip positive and negative for original X,Y,Z axis
if inverse(1)
    disp('flip X')
    V = V(end:-1:1, :, :);
end
if inverse(2)
    disp('flip Y')
    V = V(:,end:-1:1, :);
end
if inverse(3)
    disp('flip Z')
    V = V(:,:,end:-1:1);
end



% %% this worked
% V = permute(V,XYZ);
% % V = V(end:-1:1, :, :);
% V = V(:, end:-1:1, :);
% % V = V(: , :, end:-1:1);
% Dim = Dim(XYZ);

end


function [ transformed ] = SDK_transform3d(v3d,T)


% points 3d is [ x1,y1,z1 ; x2, y2, z2 ; ...
if ~(size(v3d,2)==3)
    error('Wrong dimensions vector3d. Vector should have 3 columns')
end

% T has to be a 4x4 matrix
if ~(size(T)==[4,4])
    error('Wrong dimensions transformation matrix. T shoud be 4x4.')
end

% T  has to be designed for row multiciplication
if ~(round(T(1:3,4),5)==[0;0;0])
   if (round(T(4,1:3),5)==[0,0,0]) 
       warning('T was probably transposed. This automatically repaired.')
       T = T';
   else
       disp(T)
       error ('Invalid transformation matrix.')
       
   end
end


% Add 1 to v3d

v3d(:,4) = ones(1,size(v3d,1));

% Perform tranformation

transformed = v3d*T;

% Clip off extra column

transformed(:,4) = [];



end


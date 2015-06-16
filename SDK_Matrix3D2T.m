function [ T ] = SDK_Matrix3D2T( Matrix3D )
%SDK_MATRIX3D2T Summary of this function goes here
%   Detailed explanation goes here

    M = Matrix3D.Attributes;
    T = reshape(structfun(@str2double, M),4,4);  %translation is wrong;
    scaling = T(13);
    ox = T(14);
    oy = T(15);
    oz = T(16);
 
    T(13) = ox;
    T(14) = oy;
    T(15) = oz;
    T(16) = scaling;
    
    T = T';  %transpose the T matrix because:
%   The matrix below (T')
%      1     0     0     0
%      0     1     0     0
%      0     0     1     0
%      X     Y     Z     1     

%  Allows a transformation to be like this: v*T1*T2*T3 where v is a
%  rowvector

% If one would use this instead: 
%      1     0     0     X
%      0     1     0     Y
%      0     0     1     Z
%      0     0     0     1  

% A transformation equation should like like this:  T1*v.
% This is no problem. But a series of a few T's would be:
%             T3*T2*T1*v
% It makes more sense to multiply T's in chronological order.



end


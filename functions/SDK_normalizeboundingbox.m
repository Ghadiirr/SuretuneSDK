function [ output_args ] = SDK_normalizeboundingbox( varargin )
%SDK_NORMALIZEBOUNDINGBOX Summary of this function goes here
%   Detailed explanation goes here

mincoordinates = varargin{1}.volume.getboundingbox.leftDown;
maxcoordinates = varargin{1}.volume.getboundingbox.rightUp;
minspacing = varargin{1}.volume.volumeInfo.spacing;

for i = 2:nargin
    thisReg = varargin{i};
    newmin = thisReg.volume.getboundingbox.leftDown;
    newmax = thisReg.volume.getboundingbox.rightUp;
    newspacing =  thisReg.volume.volumeInfo.spacing;
    
    mincoordinates(mincoordinates>newmin) = newmin(mincoordinates>newmin);
    maxcoordinates(maxcoordinates<newmax) = newmax(maxcoordinates<newmax);
    minspacing(minspacing>newspacing) = newspacing(minspacing>newspacing);
end

[Xq,Yq,Zq] = meshgrid(mincoordinates(1):minspacing(1):maxcoordinates(1),...
  mincoordinates(2):minspacing(2):maxcoordinates(2),...
  mincoordinates(3):minspacing(3):maxcoordinates(3));


newspacing = minspacing;
neworigin = mincoordinates;



for i = 1:nargin
    thisreg = varargin{i};
    [X,Y,Z] = thisreg.volume.getmeshgrid;
    V = thisreg.volume.voxelArray;
    
    thisreg.volume.voxelArray = permute(interp3(X,Y,Z,permute(V,[2,1,3]),Xq, Yq,Zq),[2,1,3]);
    [y,x,z] = size(thisreg.volume.voxelArray);
    thisreg.volume.volumeInfo.dimensions = [y,x,z];
    thisreg.volume.volumeInfo.spacing = newspacing;
    thisreg.volume.volumeInfo.origin = neworigin';
end





end


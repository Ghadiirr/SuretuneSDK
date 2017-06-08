function ObjInstance = makemesh(Session,V,F,name)
% MAKEMESH makes an OBJ instance with vertices and faces
%   ObjInstance = makemesh(Session,V,F,name)
%
% See also ADDNEWMESH
if nargin<3
    disp('Input Arguments are needed: V,F,name')
    return
end
ObjInstance = Obj(V,F,name);
ObjInstance.linktosession(Session);


end
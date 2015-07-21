function ObjInstance = makemesh(Session,V,F,name)
%MAKEMESH here comes a help
if nargin==1
    disp('Input Arguments are needed: V,F,name')
    return
end
ObjInstance = Obj(V,F,name);
ObjInstance.linktosession(Session);


end
function [ arrow ] = SDK_addarrow( Session,parent,startVector,endVector,name,color )
%SDK_ADDARROW Summary of this function goes here
%   Detailed explanation goes here

if nargin==4
    name = 'arrow';
    color = '#eeeeee';
end

if nargin==5
    color = '#eeeeee';
end


%parameters
radius_cilinder = 0.5;
radius_cone = 1;
min_length_cone = 1;  %


%%%%%%%%%%%%%%


p = 3;
parentregisterable = Session.getregisterable(parent);

wobjcilinder = read_wobj(['cilinder.obj']);
    cilinder.V  = wobjcilinder.vertices;
    cilinder.F = wobjcilinder.objects.data.vertices;
    cilinderObj = Obj(cilinder.V,cilinder.F,'cilinder.obj');
    cilinderObj.linktosession(Session);
    

wobjcone = read_wobj(['cone.obj']);
    cone.V  = wobjcone.vertices;
    cone.F = wobjcone.objects.data.vertices;
    coneObj = Obj(cone.V,cone.F,'cone.obj');
    coneObj.linktosession(Session);
    
    
    %Compute transformation matrix for the arrow (direction position)
    Tarrow = eye(4);
    %rotation:
    z1 = SDK_unitvector(endVector - startVector)';
    y1 = cross(z1,[1 1 1]');
    x1 = cross(y1,z1);
    Tarrow(1:3,1:3) = [x1,y1,z1];
%     Tarrow(4,1:3) = startVector;
    
    arrow = Session.addnewmesh(name,1,parent,inv(Tarrow));
    
    arrow.transform(4,1:3) = startVector';
    
    
    %compute transformation matrix for the cilinder (scaling)
    Tclndr = eye(4);
    %scaling:
    Tclndr(1,1) = 0.2; %width
    Tclndr(2,2) = 0.2; %width
    Tclndr(3,3) = norm((endVector - startVector))- min_length_cone; %size
    
    %translation
    Tclndr(4,3) = 1.27/2; %lead width
    
    % add part
    part1 = arrow.addnewpart('cilinder.obj',color,1,Tclndr,'cilinder.obj');
    
    
       
  
    %compute transformation matrix for the cone
    Tcone = eye(4);
    %scaling:
    Tcone(1,1) = 0.4; %
    Tcone(2,2) = 0.4; %
    Tcone(3,3) = min_length_cone; % norm((endVector - startVector))- min_length_cone; %size     
   
    %translation
    Tcone(4,3) = norm((endVector - startVector))- min_length_cone + 1.27/2; 
    
    % add part
    part2 = arrow.addnewpart('cone.obj',color,1,Tcone,'cone.obj');
    
    
  






end


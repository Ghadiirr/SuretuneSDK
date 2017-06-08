% Make Session object
S = Session;

%Load XML
S.loadxml;

%Show regs:
S.listregisterables;

%Add new mesh
NewMesh = S.addnewmesh('MyLabel',1,'Lead_Left',eye(4));

%Add parts:
Part = NewMesh.addnewpart('Part11b','#FFFF0000',1,eye(4),'11.obj');

%Export Session;
S.exportSession;
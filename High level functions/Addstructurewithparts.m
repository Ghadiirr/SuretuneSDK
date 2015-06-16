% Make Session object
S = Session;

%Load XML
S.LoadXML;

%Show regs:
S.getRegs;

%Add new mesh
NewMesh = S.addNewMesh('MyLabel',1,'Lead_Left',eye(4));

%Add parts:
Part = NewMesh.addNewPart('Part11b','#FFFF0000',1,eye(4),'11.obj');

%Export Session;
S.exportSession;
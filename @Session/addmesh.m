function myImportedStructure = addmesh(obj,V,F,label,parent,T,color)

label = strrep(label,' ','_');
if nargin==6
    color = rgb2hex(uisetcolor());
end
%% Make Obj
ObjInstance = Obj(V,F,[label,'.obj']);
ObjInstance.linktosession(obj);


%% Make ImportedStructure

%determine XML path
genericPath = 'obj.sessionData.SureTune2Sessions.Session.importedMeshes.Array.ImportedStructure';

try
    index = numel(eval(genericPath)) +1;
catch
    index =1;
end
path = [genericPath,'{',num2str(index),'}'];

if ischar(parent)
    %replace parent char with its object
    namelist = obj.registerables.names;
    parentindex = find(ismember(namelist,parent));
    
    if isempty(parentindex)
        warning('Parent is not known. Mesh is added without correct reference')
    else
        parent = obj.registerables.list{parentindex};
    end
end


component_args = {path,obj};
registerable_args = {parent,T,0,label}; %set accepted to false


%Make dummy elements in XML


A.parent.ref.Text = '';
A.parent.ref.Attributes.id = '';
A.transform.Matrix3D.Text = '';
A.label.Text = '';
A.label.Attributes.type = 'String';
A.label.Attributes.value = label;
A.opacity.Text = '';
A.opacity.Attributes.type = 'Double';
A.accepted.Attributes.type = 'Bool';
A.parts.Array.ImportedMeshPart = {};
A.Attributes.id = label; %#ok<STRNU>

%add dummy elements
eval([path,' = A'])

myImportedStructure = ImportedStructure(component_args, registerable_args,label,1);

obj.registerables.names{end+1} = label;
obj.registerables.list{end+1} = myImportedStructure;


%% Add MeshPart
myImportedStructure.addnewpart(label,color,1,eye(4),[label,'.obj'])


    function parentisacpc()
        
    end








end




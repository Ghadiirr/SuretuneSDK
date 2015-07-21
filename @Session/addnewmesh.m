function R = addnewmesh(varargin)
% ADDNEWMESH, a @Session function, adds an OBJ instance to a session
%   Registerable = addnewmesh(obj,label,opacity,parent,T) returns a
%   registerable
%   addnewmesh() returns a description of the input and output arguments.
%   
%   see also MAKEMESH
if nargin==1
    disp('input arguments should be: [object], label,opacity,parent,T')
    R = [];
    return
end

obj= varargin{1};
label = varargin{2};
opacity = varargin{3};
parent = varargin{4};
T = varargin{5};

warning('Build a check for unique names')
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
A.parent.ref.Attributes.id = parent;
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

R = ImportedStructure(component_args, registerable_args,label,opacity);

obj.registerables.names{end+1} = label;
obj.registerables.list{end+1} = R;





end
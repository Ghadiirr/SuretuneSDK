function R = addnewpath(varargin)
% ADDNEWDATASET is an @Session function. It adds a dataset to the
% SessionObject.
%   Dataset = SessionObject.addnewdataset(label,volumeId,Id,Stf,parent,T,volumeObject)
%   * label: readable name/description of the volume like 'Pre T1'
%   * volumeId: Unique name that refers to a volume folder
%   * id: this is used for referencing.
%   * Stf: referal to an STF object
%   * parent: a registerable object (or its matlabId).
%   * T: a 4x4 transformation matrix 
%   * VolumeObject: an object containing voxeldata (init with vo = Volume)
if nargin==1
    disp('input arguments should be: [object], label, target, entry, parent,T')
    R = [];
    return
end

% Error('Function has not been made...')

obj= varargin{1};
label = varargin{2};
target = varargin{3};
entry = varargin{4};
parent = varargin{5};
T = varargin{6};

opacity = 1;
accepted = 0;
marginRadius = 0;
beyondTargetDistance = 0;


warning('Build a check for unique names')
%determine XML path
genericPath = ['obj.sessionData.',obj.ver,'.Session.paths.Array.Path'];
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
        warning('Parent is not known. Path is added without correct reference')
    else
        parent = obj.registerables.list{parentindex};
    end
end




component_args = {path,obj};
registerable_args = {parent,T,0,label}; %set accepted to true


%Make dummy elements in XML

A.accepted.Attributes.type = 'Bool';
A.accepted.Attributes.value = accepted;

A.accepted.Attributes.Text = '';

A.parent.ref.Text = '';
A.parent.ref.Attributes.id = parent;
A.transform.Matrix3D.Text = '';

A.transform.Matrix3D.Text = '';

A.label.Text = '';
A.label.Attributes.type = 'String';
A.label.Attributes.value = label;

A.target.Point3D.Text = '';
A.target.Point3D = SDK_vector2point3d(target);

A.entry.Point3D.Text = '';
A.entry.Point3D = SDK_vector2point3d(entry);

A.opacity.Text = '';
A.opacity.Attributes.type = 'Double';
A.opacity.value = opacity;

A.marginRadius.Text = '';
A.marginRadius.Attributes.type = 'Double';
A.marginRadius.Attributes.value = marginRadius;

A.beyondTargetDistance.Text = '';
A.beyondTargetDistance.Attributes.type = 'Double';
A.beyondTargetDistance.Attributes.value = beyondTargetDistance;

%add dummy elements
eval([path,' = A;'])

R = Path(component_args, registerable_args,label,target,entry,opacity,marginRadius,beyondTargetDistance);

%Add to registerable list
obj.registerables.names{end+1} = label;
obj.registerables.list{end+1} = R;








end
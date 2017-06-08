function R = addnewdataset(varargin)
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
    disp('input arguments should be: [object], label,volumeId,Id,Stf,parent,T,VolumeObject')
    R = [];
    return
end

obj= varargin{1};
label = varargin{2};
volumeId = varargin{3};
Id = varargin{4};
stf = varargin{5};
parent = varargin{6};
T = varargin{7};
vObject = varargin{8};

warning('Build a check for unique names')
%determine XML path
genericPath = ['obj.sessionData.',obj.ver,'.Session.datasets.Array.Dataset'];
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
registerable_args = {parent,T,0,label}; %set accepted to true


%Make dummy elements in XML

A.label.Text = '';
A.label.Attributes.type = 'String';
A.label.Attributes.value = label;
A.volumeId.text='';
A.volumeId.Attributes.type='String';
A.accepted.Attributes.type = 'Bool';

A.parent.ref.Text = '';
A.parent.ref.Attributes.id = parent;
A.transform.Matrix3D.Text = '';

A.stf.Null.Text = [];


A.Attributes.id = label; %#ok<STRNU>

%add dummy elements
eval([path,' = A'])


%Add volume to volume list
obj.volumeStorage.names{end+1} = label;
obj.volumeStorage.list{end+1} = vObject;

R = Dataset(component_args, registerable_args,label,volumeId,Id,stf);
R.volume = vObject;

%Verify if a masterdatset is selected
if any(ismember(fieldnames(obj.sessionData.(obj.ver).Session.masterDataset),'Null'))
    obj.sessionData.(obj.ver).Session.masterDataset = [];
    obj.sessionData.(obj.ver).Session.masterDataset.ref.Attributes.id = parent.id;
    obj.sessionData.(obj.ver).Session.masterDataset.ref.Text = [];
end
    


%Add to registerable list
obj.registerables.names{end+1} = label;
obj.registerables.list{end+1} = R;








end
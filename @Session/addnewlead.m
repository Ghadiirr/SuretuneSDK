function [ output_args ] = addnewlead( varargin )
%ADDNEWSTIMPLAN Summary of this function goes here
%   Detailed explanation goes here

% addnewstimplan(S2,0,L,'True','2','60','120','1 0 0 0','0 0 0 0','mynote')

if nargin==1
    disp('input arguments should be: [object], .....')
    R = [];
    return
elseif nargin~=11
    disp(['not enough input arguments (',num2str(nargin),'/11)...'])
end
        obj = varargin{1};
        leadType = varargin{2};
        proximal = varargin{3};
        distal = varargin{4};
        label = varargin{5};
        parent = varargin{6};
        T = varargin{7};

        
       
        
     
        %determine XML path
genericPath = 'obj.sessionData.SureTune3Sessions.Session.leads.Array.Lead';

try
    index = numel(eval(genericPath)) +1;
catch
    index =1;
end
path = [genericPath,'{',num2str(index),'}'];



% %comute signature
% signature_input = ['"',label,'" ',...
%   voltageBasedStimulation,'" "',...
%     pulseWidth,'" "',...
%     pulseFrequency,'" "',...
%     activeRings,'" "',...
%     contactsGrounded,'" "',...
%     annotation,'"'];
%     
%     [~,result] = system([fullfile(obj.homeFolder,'thirdParty','signature','SignatureHasher.exe '),signature_input ])

component_args = {path,obj};
registerable_args = {parent,T,0,label}; %set accepted to false


%Make dummy elements in XML


A.parent.ref.Text = '';
A.parent.ref.Attributes.id = parent;
A.transform.Matrix3D.Text = '';
A.label.Text = '';
A.label.Attributes.type = 'String';
A.label.Attributes.value = label;

A.leadType.Enum.Text = '';
A.leadType.Enum.Attributes.type = 'LeadType';
A.leadType.Enum.Attributes.value = leadType;

A.distal.Point3D.Text = '';
A.proximal.Point3D.Text = '';

A.stimPlans.Array.Text = '';

A.Attributes.id = label; %#ok<STRNU>

%add dummy elements
eval([path,' = A'])

R = Lead(component_args,registerable_args,distal,proximal,[], leadType,label);

obj.registerables.names{end+1} = label;
obj.registerables.list{end+1} = R;


        
end


function [ output_args ] = addnewstimplan( varargin )
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
        vta = varargin{2};
        lead = varargin{3};
        label = varargin{4};
        voltageBasedStimulation = varargin{5};
        stimulationValue = varargin{6};
        pulseWidth = varargin{7};
        pulseFrequency = varargin{8};
        activeRings = varargin{9};
        contactsGrounded = varargin{10};
        annotation = varargin{11};
        
        



% check validity of input

if ~isstruct(vta)
    disp('No VTA attached')
    vta = 0;
end

if ~isa(lead,'Lead')
    error('Lead should be of type Lead')
end

if ~ischar(label)
    label = 'nolabel';
    disp('Label is set to no label')
end

if ~strcmp(voltageBasedStimulation,'True') && ~strcmp(voltageBasedStimulation,'False')
    error('voltageBasedStimulation should be ''True'' or ''False''')
end

if ~ischar(stimulationValue)
    try
        stimulationValue = num2str(stimulationValue);
    catch
        error('StimulationValue should be a string')
    end
end

if ~ischar(pulseWidth)
    try
        pulseWidth = num2str(pulseWidth);
    catch
        error('pulseWidth should be a string')
    end
end

if ~ischar(pulseFrequency)
    try
        pulseFrequency = num2str(pulseFrequency);
    catch
        error('pulseFrequency should be a string')
    end
end

if ~ischar(activeRings) || ~numel(activeRings)==7
    if isa(activeRings,'double') || isa(activeRings,'logical')
    error('activeRings should be 0 0 0 0 or 1 0 0 0 or 1 1 0 0 or any other string consisting of 4 booleans separated by spaces')
end

      
if ~ischar(contactsGrounded) || ~numel(contactsGrounded)==7
    error('contactsGrounded should be 0 0 0 0 or 1 0 0 0 or 1 1 0 0 or any other string consisting of 4 booleans separated by spaces')
end
            
if ~ischar(annotation) || numel(annotation)==0
    annotation = 'no annotation';
end
    

        %determine XML path
genericPath = [lead.path,'.stimPlans.Array.StimPlan'];

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

%Make dummy elements in XML

A.label.Text = '';
A.label.Attributes.type = 'String';
A.label.Attributes.value = label;

A.voltageBasedStimulation.Text = '';
A.voltageBasedStimulation.Attributes.type = 'Bool';
A.voltageBasedStimulation.Attributes.value = 'True';

A.stimulationValue.Text = '';
A.stimulationValue.Attributes.type = 'Double';
A.stimulationValue.Attributes.value = stimulationValue;


A.pulseWidth.Text = '';
A.pulseWidth.Attributes.type = 'Int';
A.pulseWidth.Attributes.value = pulseWidth;



A.pulseFrequency.Text = '';
A.pulseFrequency.Attributes.type = 'Decimal';
A.pulseFrequency.Attributes.value = pulseFrequency;

A.activeRings.BoolArray.Text = activeRings;
A.contactsGrounded.BoolArray.Text = contactsGrounded;

A.annotation.Text ='';
A.annotation.Attributes.type = 'String';
A.annotation.Attributes.value = annotation;


SP = StimPlan(vta,lead,label,voltageBasedStimulation,stimulationValue,pulseWidth,pulseFrequency,activeRings,contactsGrounded,annotation);

%add to XML
eval([path,' = A;'])


        
end


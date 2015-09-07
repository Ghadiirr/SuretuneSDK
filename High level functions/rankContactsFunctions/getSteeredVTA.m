function [f,v]=getSteeredVTA(Amplitude, Degrees)
%% Load input arguments file
cd(fileparts(mfilename('fullpath')))
% read inputArguments
InputArguments = XML2struct('InputArgumentsX5.xml');
handles.NumberOfContacts = str2double(InputArguments.Settings.NrOfElectrodes.Text);

handles.GridSpacingX = str2double(InputArguments.Settings.GridSpacing.z.Text);
handles.GridSpacingY = str2double(InputArguments.Settings.GridSpacing.z.Text);
handles.GridSpacingZ = str2double(InputArguments.Settings.GridSpacing.z.Text);

handles.GridOriginX = str2double(InputArguments.Settings.GridOrigin.z.Text);
handles.GridOriginY = str2double(InputArguments.Settings.GridOrigin.z.Text);
handles.GridOriginZ = str2double(InputArguments.Settings.GridOrigin.z.Text);

handles.GridDimensionZ = str2double(InputArguments.Settings.GridDimension.z.Text);
handles.GridDimensionY = str2double(InputArguments.Settings.GridDimension.y.Text);
handles.GridDimensionX = str2double(InputArguments.Settings.GridDimension.x.Text);

handles.LeadModel = InputArguments.Settings.LeadModel.Text;


%% load field from bin files

% Generate filenames
FileName = 'ExportedGridDataX5.bin';

% Open the files for a specific ring
fileID = fopen(FileName);

%Read files
Atemp = fread(fileID, inf, 'float32');

% Reformat fields
FieldDataV = reshape(Atemp, [handles.GridDimensionX handles.GridDimensionY handles.GridDimensionZ]);

% clse bin file
fclose(fileID);

%% visualize the data

% Gridpoints location

x = handles.GridOriginX:handles.GridSpacingX:(handles.GridDimensionX-1)*handles.GridSpacingX+handles.GridOriginX;
y = handles.GridOriginY:handles.GridSpacingY:(handles.GridDimensionY-1)*handles.GridSpacingY+handles.GridOriginY;
z = handles.GridOriginZ:handles.GridSpacingZ:(handles.GridDimensionZ-1)*handles.GridSpacingZ+handles.GridOriginZ;

% Isosurface for field
% Userdefined settings
ScaleFactor = Amplitude; % scale the electricpotiential distribution  ==mA
ScaledFieldDataV = FieldDataV*ScaleFactor;
MaximumVoltage = max(ScaledFieldDataV(:));
handles.PulseWidth = 60;
handles.AxonDiameter = 2.5;
handles.NumberOfActiveRings = 3;
SteeringAmount = 1;
direction = Degrees; % degrees clockwise

IsolevelV = QueryThresholdTableVfieldSureStim1(...
       MaximumVoltage(1), handles.PulseWidth, handles.AxonDiameter, handles.NumberOfActiveRings, SteeringAmount );
% IsolevelV = 0.5;                
                
[f, v] = isosurface(x, y, z, ScaledFieldDataV, IsolevelV);
% 
% %Rotate
Rtest = rotationmat3D(deg2rad(direction),[0 0 1]);

%Flip anterior/posterior
Rflip = eye(3);Rflip(2,2) = -1;
try
v=v*Rtest*Rflip;
catch
    disp('huh?')
end


%get to mm domain:
v = v*1000;

% % patch
% handles.FieldHandle = patch('Faces', f,'Vertices',v);
% set(handles.FieldHandle, 'FaceColor', rand(1,3), 'EdgeColor', 'none');
% alpha(handles.FieldHandle, 0.8);
% lighting gouraud
% camlight('left')
% axis equal;
% grid off
% rotate3d

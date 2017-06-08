function [ FieldThreshold ] = QueryThresholdTableEfieldSureStim1( Amplitude, PulseWidth, AxonDiameter, NumberOfRings, SteeringAmount)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% % Test code
% Amplitude = 3;
% PulseWidth = 210;
% AxonDiameter = 2;
% NumberOfRings = 4;
% SteeringAmount = 0.5; 

% with steering included


%% Load look-up table and input argument file
load('LookUpTableVfieldSteering.mat');
InputArgumentsLookUpTable = XML2struct('InputArgumentsLookUpTableVfieldSteering.xml');

% Read input arguments for threshold look-up table
AmplitudeOrigin = str2double(InputArgumentsLookUpTable.Settings.TableOrigin.Dim1.Text);
PulseWidthOrigin = str2double(InputArgumentsLookUpTable.Settings.TableOrigin.Dim2.Text);
AxonDiameterOrigin = str2double(InputArgumentsLookUpTable.Settings.TableOrigin.Dim3.Text);
NumberOfRingsOrigin = str2double(InputArgumentsLookUpTable.Settings.TableOrigin.Dim4.Text);
SteeringOrigin = str2double(InputArgumentsLookUpTable.Settings.TableOrigin.Dim5.Text);

AmplitudeSpacing = str2double(InputArgumentsLookUpTable.Settings.TableSpacing.Dim1.Text);
PulseWidthSpacing = str2double(InputArgumentsLookUpTable.Settings.TableSpacing.Dim2.Text);
AxonDiameterSpacing = str2double(InputArgumentsLookUpTable.Settings.TableSpacing.Dim3.Text);
NumberOfRingsSpacing = str2double(InputArgumentsLookUpTable.Settings.TableSpacing.Dim4.Text);
SteeringSpacing = str2double(InputArgumentsLookUpTable.Settings.TableSpacing.Dim5.Text);

AmplitudeDimension = str2double(InputArgumentsLookUpTable.Settings.TableDimension.Dim1.Text);
PulseWidthDimension = str2double(InputArgumentsLookUpTable.Settings.TableDimension.Dim2.Text);
AxonDiameterDimension = str2double(InputArgumentsLookUpTable.Settings.TableDimension.Dim3.Text);
NumberOfRingsDimension = str2double(InputArgumentsLookUpTable.Settings.TableDimension.Dim4.Text);
SteeringDimension = str2double(InputArgumentsLookUpTable.Settings.TableDimension.Dim5.Text);

AmplitudeEnd = AmplitudeOrigin+AmplitudeSpacing*(AmplitudeDimension-1);
PulseWidthEnd = PulseWidthOrigin+PulseWidthSpacing*(PulseWidthDimension-1);
AxonDiameterEnd = AxonDiameterOrigin+AxonDiameterSpacing*(AxonDiameterDimension-1);
NumberOfRingsEnd = NumberOfRingsOrigin+NumberOfRingsSpacing*(NumberOfRingsDimension-1);
SteeringEnd = SteeringOrigin+SteeringSpacing*(SteeringDimension-1);

AmplitudeList = AmplitudeOrigin:AmplitudeSpacing:AmplitudeEnd;
PulseWidthList = PulseWidthOrigin:PulseWidthSpacing:PulseWidthEnd;
AxonDiameterList = AxonDiameterOrigin:AxonDiameterSpacing:AxonDiameterEnd;
NumberOfRingsList = NumberOfRingsOrigin:NumberOfRingsSpacing:NumberOfRingsEnd;
SteeringList = SteeringOrigin:SteeringSpacing:SteeringEnd;

% Check if settings are larger than what we have data for.
if Amplitude > AmplitudeList(end)
    Amplitude = AmplitudeList(end);
end
if Amplitude < AmplitudeList(1)
    Amplitude = AmplitudeList(1);
end
if PulseWidth > PulseWidthList(end)
    PulseWidth = PulseWidthList(end);
end
if AxonDiameter > AxonDiameterList(end)
    AxonDiameter = AxonDiameterList(end);
end

% %Derive index for look-up table
% AmplitudeIndex = find(AmplitudeList == Amplitude);
% PulseWidthIndex = find(PulseWidthList == PulseWidth);
% AxonDiameterIndex = find(AxonDiameterList == AxonDiameter);
% NumberOfRingsIndex = find(NumberOfRingsList == NumberOfRings);

% Derive electric field threshold with linear interpolation
[X,Y,Z,C,D] = ndgrid(AmplitudeList, PulseWidthList,...
    AxonDiameterList, NumberOfRingsList, SteeringList);

% FieldThreshold = interpn(X,Y,Z,C,LookUpTable,...
%     AmplitudeIndex, PulseWidthIndex, AxonDiameterIndex, NumberOfRingsIndex);
%  Amplitude
%  PulseWidth 
%  AxonDiameter 
%  NumberOfRings 
%  SteeringAmount
FieldThreshold = interpn(X,Y,Z,C,D, LookUpTable,...
    Amplitude, PulseWidth, AxonDiameter, NumberOfRings, SteeringAmount)



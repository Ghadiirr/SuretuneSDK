function varargout = loadNifti(varargin)
% LOADNIFTI MATLAB code for loadNifti.fig
%      LOADNIFTI, by itself, creates a new LOADNIFTI or raises the existing
%      singleton*.
%
%      H = LOADNIFTI returns the handle to a new LOADNIFTI or the handle to
%      the existing singleton*.
%
%      LOADNIFTI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADNIFTI.M with the given input arguments.
%
%      LOADNIFTI('Property','Value',...) creates a new LOADNIFTI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before loadNifti_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to loadNifti_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help loadNifti

% Last Modified by GUIDE v2.5 04-Jan-2016 11:18:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @loadNifti_OpeningFcn, ...
    'gui_OutputFcn',  @loadNifti_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before loadNifti is made visible.
function loadNifti_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to loadNifti (see VARARGIN)

% Choose default command line output for loadNifti
handles.output = hObject;

localvariables = evalin('base','whos');
indices = ismember({localvariables.class},'Session');
Sessions = localvariables(indices);
optionlist = {};
if numel(Sessions)
    for si = 1:numel(Sessions);
        variablename = Sessions(si).name;
        thissession = evalin('base',variablename);
        UserData{si} = thissession;
        try patientname = thissession.patient.name;
        catch
            patientname = 'Empty Session';
        end
        optionlist{si} = [Sessions(si).name,' (',patientname,')'];
    end
else
    optionlist = {'No available sessions in workspace'};
    disp('No available sessions in workspace')
    handles.output=0;
    figure1_CloseRequestFcn(hObject, eventdata, handles)
    return
end

handles.Sessions  = UserData;

set(handles.sessiondropdown,'String',optionlist);

% Update handles structure
guidata(hObject, handles);

updateinheritanceoptions(handles);











% UIWAIT makes loadNifti wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function updateinheritanceoptions(handles)
index  = get(handles.sessiondropdown,'Value');
data = handles.Sessions;
thissession = data{index};

[names,types] = thissession.listregisterables;
inheritancestring = names(ismember(types,'Dataset'));

acpc = names(ismember(types,'ACPCIH'));
if ~isempty(acpc)
    inheritancestring{end+1} = acpc{1};
end

inheritancestring{end+1} = 'Default';
set(handles.inheritancedropdown,'String',inheritancestring)
set(handles.inheritancedropdown,'Value',1);










% --- Outputs from this function are returned to the command line.
function varargout = loadNifti_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isfield(handles,'output')
    handles.output = 0;
end
varargout{1} = handles.output;


% --- Executes on selection change in sessiondropdown.
function sessiondropdown_Callback(hObject, eventdata, handles)
% hObject    handle to sessiondropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateinheritanceoptions(handles);

% Hints: contents = cellstr(get(hObject,'String')) returns sessiondropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sessiondropdown


% --- Executes during object creation, after setting all properties.
function sessiondropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessiondropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browsebtn.
function browsebtn_Callback(hObject, eventdata, handles)
% hObject    handle to browsebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName,pathName] = uigetfile('*.nii','Select Nifti file');
handles.niftidir = fullfile(pathName,fileName);


%load nifti
handles.nii = load_nii(fullfile(pathName,fileName));

% handles.niifile.dimensions = a.hdr.dime.dim(2:4);
% handles.niifile.rotortient = a.hdr.hist.rot_orient;
% handles.niifile.T = [a.hdr.hist.srow_x;...
%     a.hdr.hist.srow_y;...
%     a.hdr.hist.srow_z;...
%     0,0,0,1]';
%


if handles.nii.original.hdr.hist.sform_code
    if get(handles.inheritancedropdown,'Value')==numel(get(handles.inheritancedropdown,'String'))
        set(handles.useembeddedt,'Enable','on');
    else
        set(handles.useembeddedt,'Enable','off');
        set(handles.useembeddedt,'Value',0);
    end
else
    set(handles.useembeddedt,'Enable','off');
    set(handles.useembeddedt,'Value',0);
end


set(handles.browsebtn,'String',handles.niftidir);



% Update handles structure
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in inheritancedropdown.
function inheritancedropdown_Callback(hObject, eventdata, handles)
% hObject    handle to inheritancedropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'nii')
    return
end

if handles.nii.original.hdr.hist.sform_code
    if get(handles.inheritancedropdown,'Value')==numel(get(handles.inheritancedropdown,'String'))
        set(handles.useembeddedt,'Enable','on');
    else
        set(handles.useembeddedt,'Enable','off');
        set(handles.useembeddedt,'Value',0);
    end
else
    set(handles.useembeddedt,'Enable','off');
    set(handles.useembeddedt,'Value',0);
end


% Hints: contents = cellstr(get(hObject,'String')) returns inheritancedropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inheritancedropdown


% --- Executes during object creation, after setting all properties.
function inheritancedropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inheritancedropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function volumename_Callback(hObject, eventdata, handles)
% hObject    handle to volumename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volumename as text
%        str2double(get(hObject,'String')) returns contents of volumename as a double


% --- Executes during object creation, after setting all properties.
function volumename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volumename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over volumename.
function volumename_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to volumename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in executebtn.
function newdataset = executebtn_Callback(hObject, eventdata, handles)
% hObject    handle to executebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'nii')
    disp('No NII loaded')
    return
end


thissession = handles.Sessions{get(handles.sessiondropdown,'Value')};

% Make new Volume
I.id = [strrep(strrep(strrep(get(handles.volumename,'String'),' ','_'),'(','_'),')','_'),strrep(strrep(num2str(clock),' ',''),'.','')];
I.dimensions = size(handles.nii.img);
I.spacing = handles.nii.hdr.dime.pixdim(2:4);
I.origin = [handles.nii.hdr.hist.srow_x(4), handles.nii.hdr.hist.srow_y(4), handles.nii.hdr.hist.srow_z(4)];
I.rescaleSlope = handles.nii.original.hdr.dime.scl_slope;
I.rescaleIntercept = handles.nii.original.hdr.dime.scl_inter;
I.scanDirection = 'unknown';
I.imageType = 'unknown';
I.seriesNumber=0;
I.modality = 'unknown';
I.name = thissession.patient.name;
I.patientId = thissession.patient.patientID;
I.gender = thissession.patient.gender;
I.dateofbirth=thissession.patient.dateOfBirth;

if I.rescaleSlope < 1
    I.rescaleSlope = 1;
end


%flip volume depending on checkboxes
% +x = Right  +y = Anterior  +z = Superior. in Nifti (RAS)
% +x  = Left  +y = Posterior +z  = Superior. in STU. (LPS)
Tflip = eye(4);
if get(handles.flipxcheck,'Value')
    Tflip(1,1) = -1;
    handles.nii.img = flip(handles.nii.img,1);
    I.origin(1) = I.origin(1)*-1;
end
if get(handles.flipycheck,'Value')
    Tflip(2,2) = -1;
    handles.nii.img = flip(handles.nii.img,2);
    I.origin(2) = I.origin(2)*-1;
end
if get(handles.flipzcheck,'Value')
    Tflip(3,3) = -1;
    handles.nii.img = flip(handles.nii.img,3);
end

handles.nii.img = double(handles.nii.img);

if max(handles.nii.img(:))<=1
    handles.nii.img = handles.nii.img*1000;
end




% Method 2
% http://nifti.nimh.nih.gov/nifti-1/documentation/nifti1fields/nifti1fields_pages/quatern.html
% http://nifti.nimh.nih.gov/nifti-1/documentation/nifti1fields/nifti1fields_pages/qsform.html
% http://nifti.nimh.nih.gov/nifti-1/documentation/nifti1fields/nifti1fields_pages/qsform_usage

if handles.nii.original.hdr.hist.qform_code > 0
    qb = handles.nii.original.hdr.hist.quatern_b;
    qc = handles.nii.original.hdr.hist.quatern_c;
    qd = handles.nii.original.hdr.hist.quatern_d;
    qa = sqrt(1-qb^2-qc^2-qd^2);
    
    R = qGetR([qa,qb,qc,qd])';
    T_rotation = eye(4);
    T_rotation(1:3,1:3) = R;
    
    
    pixdim  =  handles.nii.original.hdr.dime.pixdim;
    T_scaling = [pixdim(2), 0, 0, 0;...
        0, pixdim(3), 0, 0;...
        0, 0, pixdim(4), 0;...
        0, 0, 0, 1];
    
    T_translation = eye(4);
    T_translation(1,4) = handles.nii.original.hdr.hist.qoffset_x;
    T_translation(2,4) = handles.nii.original.hdr.hist.qoffset_y;
    T_translation(3,4) = handles.nii.original.hdr.hist.qoffset_z;
    
    
    Tnii = (T_rotation'*T_translation')';
else
    if handles.nii.original.hdr.hist.sform_code > 0
        Tnii = [handles.nii.original.hdr.hist.srow_x;...
            handles.nii.original.hdr.hist.srow_y;...
            handles.nii.original.hdr.hist.srow_z;...
            0 0 0 1];
    else
        Tnii = eye(4);
    end
end




inheritancestrings = get(handles.inheritancedropdown,'String');
inheritancevalue = get(handles.inheritancedropdown,'Value');
thisinheritance = inheritancestrings{inheritancevalue};

switch thisinheritance
    case 'Default'
        Stf = '';
        parent = thissession.getregisterable(1);
        T = eye(4);
        
    case 'acpcCoordinateSystem';
        thisRegisterable = thissession.getregisterable(thisinheritance);
        Stf = ''
        parent = thisRegisterable.parent;
        if ~isa(parent,'Dataset')
            parent = thisRegisterable;
        end
        T = thisRegisterable.transform;
        
        
    otherwise
        thisRegisterable = thissession.getregisterable(thisinheritance);
        Stf = thisRegisterable.stf;
        parent = thisRegisterable.parent;
        if ~isa(parent,'Dataset')
            parent = thisRegisterable;
        end
        T = thisRegisterable.transform;
        
end

%make volume
handles.newVolume = Volume;
handles.newVolume.newvolume(I,handles.nii.img,thissession)

%make dataset
newdataset = thissession.addnewdataset(get(handles.volumename,'String'),I.id,I.id,Stf,parent,T,handles.newVolume);
assignin('base','newdataset',newdataset)
newdataset
disp('newdataset is available as a workspace variable')



function modalitybox_Callback(hObject, eventdata, handles)
% hObject    handle to modalitybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modalitybox as text
%        str2double(get(hObject,'String')) returns contents of modalitybox as a double


% --- Executes during object creation, after setting all properties.
function modalitybox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modalitybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scandirectionbox_Callback(hObject, eventdata, handles)
% hObject    handle to scandirectionbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scandirectionbox as text
%        str2double(get(hObject,'String')) returns contents of scandirectionbox as a double


% --- Executes during object creation, after setting all properties.
function scandirectionbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scandirectionbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flipxcheck.
function flipxcheck_Callback(hObject, eventdata, handles)
% hObject    handle to flipxcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flipxcheck


% --- Executes on button press in flipzcheck.
function flipzcheck_Callback(hObject, eventdata, handles)
% hObject    handle to flipzcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flipzcheck


% --- Executes on button press in flipycheck.
function flipycheck_Callback(hObject, eventdata, handles)
% hObject    handle to flipycheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flipycheck


% --- Executes on button press in useembeddedt.
function useembeddedt_Callback(hObject, eventdata, handles)
% hObject    handle to useembeddedt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useembeddedt


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

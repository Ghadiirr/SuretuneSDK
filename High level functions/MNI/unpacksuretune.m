function [  ] = VNA2NIFTI_GUI(  )
%GUI Summary of this function goes here
%   Detailed explanation goes here


GUI.fh = figure('Units','pixels',...
    'position',[500 500 400 500],...
    'menubar','none',...
    'name','VisualDBSlab - unpack SureTune',...
    'numbertitle','off',...
    'resize','off');



%window 1
GUI.handles(1).pbnext = uicontrol('style','push',...
    'units','pix',...
    'position',[210 10 180 40],...
    'fontsize',12,...
    'string','Next',...
    'enable','off');

GUI.handles(1).text = uicontrol('style','text',...
    'units','pix',...
    'position',[20,470,200,20],...
    'horizontalAlignment','left',...
    'String','Select a SureTune Session file...');

GUI.handles(1).pbbrowse = uicontrol('style','push',...
    'units','pix',...
    'position',[20 440 60 30],...
    'fontsize',10,...
    'string','Browse',...
    'enable','on');

GUI.handles(1).details = uicontrol('style','text',...
    'units','pix',...
    'position',[20,180,480,250],...
    'HorizontalAlignment','left',...
    'String',sprintf(''));

%window 2

GUI.handles(2).text = uicontrol('style','text',...
    'units','pix',...
    'position',[20,470,400,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'String','Select one or more shapes to export (you can use ctrl and shift keys).');



GUI.handles(2).listboxVNA = uicontrol('style','listbox',...
    'units','pix',...
    'position',[20,340,360, 100],...
    'visible','off',...
    'max',1000,...
    'min',0,...
    'callback',{@w2_VNAlistbox},...
    'value',[],...
    'enable','on');

GUI.handles(2).VNAcheckbox = uicontrol('style','checkbox',...
    'units','pix',...
    'position',[20,440,200,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'Value',0,...
    'callback',{@w2_deselectVNA},...
    'String','VNAs:');

GUI.handles(2).atlascheckbox = uicontrol('style','checkbox',...
    'units','pix',...
    'position',[20,300,200,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'Value',0,...
    'callback',{@w2_deselectatlas},...
    'String','Atlases:');


GUI.handles(2).listboxAtlas = uicontrol('style','listbox',...
    'units','pix',...
    'position',[20,250,360, 50],...
    'visible','off',...
    'max',1000,...
    'min',0,...
    'value',[],...
    'callback',{@w2_Atlaslistbox},...
    'enable','on');
%




GUI.handles(2).IBScheckbox = uicontrol('style','checkbox',...
    'units','pix',...
    'position',[20,210,200,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'Value',0,...
    'callback',{@w2_deselectIBS},...
    'String','Intensity based segmentations:');


GUI.handles(2).listboxIBS = uicontrol('style','listbox',...
    'units','pix',...
    'position',[20,160,360, 50],...
    'visible','off',...
    'max',1000,...
    'min',0,...
    'value',[],...
    'callback',{@w2_IBSlistbox},...
    'enable','on');


GUI.handles(2).MBScheckbox = uicontrol('style','checkbox',...
    'units','pix',...
    'position',[20,110,200,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'Value',0,...
    'callback',{@w2_deselectMBS},...
    'String','Manual Segmentations:');



GUI.handles(2).listboxMBS = uicontrol('style','listbox',...
    'units','pix',...
    'position',[20,60,360, 50],...
    'visible','off',...
    'max',1000,...
    'min',0,...
    'value',[],...
    'callback',{@w2_MBSlistbox},...
    'enable','on');



GUI.handles(2).pbnext = uicontrol('style','push',...
    'units','pix',...
    'position',[210 10 180 40],...
    'fontsize',12,...
    'string','Next',...
    'visible','off',...
    'enable','on');



% GUI.handles(2).listboxManSeg = uicontrol('style','listbox',...
%                 'units','pix',...
%                 'position',[20,310,200,100],...
%                 'visible','off',...
%                 'enable','off');
%
% GUI.handles(2).listboxIBSeg = uicontrol('style','listbox',...
%                 'units','pix',...
%                 'position',[20,190,200,100],...
%                 'visible','off',...
%                 'enable','off');


%window 3

GUI.handles(3).text = uicontrol('style','text',...
    'units','pix',...
    'position',[20,470,300,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'String','Select one or more spaces:');

GUI.handles(3).pbnext = uicontrol('style','push',...
    'units','pix',...
    'position',[210 10 180 40],...
    'fontsize',12,...
    'string','Next',...
    'visible','off',...
    'enable','on');

%window 4

GUI.handles(4).text = uicontrol('style','text',...
    'units','pix',...
    'position',[20,470,300,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'String','Select only the T1 image for MNI warp:');

GUI.handles(4).pbnext = uicontrol('style','push',...
    'units','pix',...
    'position',[210 10 180 40],...
    'fontsize',12,...
    'string','Next',...
    'visible','off',...
    'enable','off');



%window 5

GUI.handles(5).pbcompute = uicontrol('style','push',...
    'units','pix',...
    'position',[210 10 180 40],...
    'fontsize',12,...
    'string','Compute',...
    'visible','off',...
    'enable','off');

GUI.handles(5).text = uicontrol('style','text',...
    'units','pix',...
    'position',[20,470,200,20],...
    'horizontalAlignment','left',...
    'visible','off',...
    'String','Select output folder...');

GUI.handles(5).pbbrowse = uicontrol('style','push',...
    'units','pix',...
    'position',[20 440 60 30],...
    'fontsize',10,...
    'string','Browse',...
    'visible','off',...
    'enable','on');

GUI.handles(5).details = uicontrol('style','text',...
    'units','pix',...
    'position',[20,180,480,250],...
    'HorizontalAlignment','left',...
    'visible','off',...
    'String',sprintf(''));

GUI.handles(5).waitbaraxes = axes('Units','pix',...
    'Position',[20 55 360 20],...
    'Xtick',[],...
    'Ytick',[],...
    'Xlim',[0 1000],...
    'box','on',...
    'visible','off');




set(GUI.handles(1).pbnext,'callback',{@w1_next,GUI})
set(GUI.handles(1).pbbrowse,'callback',{@w1_browse,GUI})
set(GUI.handles(2).pbnext,'callback',{@w2_next,GUI})
set(GUI.handles(3).pbnext,'callback',{@w3_next,GUI})
set(GUI.handles(4).pbnext,'callback',{@w4_next,GUI})
set(GUI.handles(5).pbbrowse,'callback',{@w5_browse,GUI})
set(GUI.handles(5).pbcompute,'callback',{@w5_compute,GUI})




guidata(GUI.fh,GUI);





% general functions
function next(idx,hObject)
GUI = initialize(idx+1,hObject);

subHandles = fieldnames(GUI.handles(idx));
for subHandleIdx=1:numel(subHandles)
    set(GUI.handles(idx).(subHandles{subHandleIdx}),'visible','off')
end



subHandles = fieldnames(GUI.handles(idx+1));
for subHandleIdx=1:numel(subHandles)
    set(GUI.handles(idx+1).(subHandles{subHandleIdx}),'visible','on')
end



function [GUI] = initialize(idx,hObject)
GUI = guidata(hObject);
switch(idx)
    case 2
        
        %Update VNA listnbox
        VNAstrings = {};
        for iStimPlan = 1:GUI.nVNAs
            name = GUI.session.therapyPlanStorage{iStimPlan}.label;
            amp = num2str(GUI.session.therapyPlanStorage{iStimPlan}.stimulationValue);
            activerings = GUI.session.therapyPlanStorage{iStimPlan}.activeRings;
            
            string = sprintf('%s: %s (%s)',name,amp,activerings);
            VNAstrings{iStimPlan} = string;
            %                     GUI.handles(2).(['chckbox',num2str(iStimPlan)]) = uicontrol('style','checkbox',...
            %                     'units','pix',...
            %                     'position',[20,470 - 20*iStimPlan,200,20],...
            %                     'visible','off',...
            %                     'String',string,...
            %                     'callback',{@w2_addVNA,iStimPlan});
            
        end
        set(GUI.handles(2).listboxVNA,'String',VNAstrings)
        
        %Update IBS listnbox
        IBSstrings = {};
        [allids,types] = GUI.session.listregisterables;
        IBSids = allids(ismember(types,'ImageBasedStructureSegmentation'));
        
        for iIBS = 1:GUI.nIBS
            thisIBS = GUI.session.getregisterable(IBSids{iIBS});
            name = thisIBS.label;
            IBSstrings{iIBS} = name;
        end
        set(GUI.handles(2).listboxIBS,'String',IBSstrings)
        
        %Update MBS listnbox
        MBSstrings = {};
        [allids,types] = GUI.session.listregisterables;
        MBSids = allids(ismember(types,'ManualStructureSegmentation'));
        
        for iMBS = 1:GUI.nMBS
            thisMBS = GUI.session.getregisterable(MBSids{iMBS});
            name = thisMBS.label;
            MBSstrings{iMBS} = name;
        end
        set(GUI.handles(2).listboxMBS,'String',MBSstrings)
        
        
        %Update Atlas listbox
        Atlasstrings = {};
        [allids,types] = GUI.session.listregisterables;
        Atlasids = allids(ismember(types,'Atlas'));
        for iAtlas = 1:GUI.nAtlases
            thisAtlas = GUI.session.getregisterable(Atlasids{iAtlas});
            hemi = thisAtlas.hemisphere;
            group = thisAtlas.group;
            if contains(group,'Definition')
                group = '';
            end
            name = [hemi,'  ',group];
            Atlasstrings{iAtlas} = name;
        end
        set(GUI.handles(2).listboxAtlas,'String',Atlasstrings)
        
        
        
        GUI.vnaSelect = zeros(GUI.nVNAs,1);
        
    case 3
        
        %Make checkboxes for all Datasets
        [names,types] = GUI.session.listregisterables;
        indexes = find(ismember(types,'Dataset'));
        
        for iDataset = 1:GUI.nDatasets
            thisDataset = GUI.session.getregisterable(indexes(iDataset));
            
            
            modality = thisDataset.label;
            id = thisDataset.matlabId;
            
            
            
            string = sprintf('%s (%s)',modality,id);
            
            GUI.handles(3).(['chckbox',num2str(iDataset)]) = uicontrol('style','checkbox',...
                'units','pix',...
                'position',[20,470 - 20*iDataset,200,20],...
                'visible','off',...
                'String',string,...
                'callback',{@w3_addDataset,iDataset});
            
        end
        GUI.datasetSelect = zeros(GUI.nDatasets,1);
        
    case 4
        
        %Make checkboxes for all Datasets
        [names,types] = GUI.session.listregisterables;
        indexes = find(ismember(types,'Dataset'));
        
        for iDataset = 1:GUI.nDatasets
            thisDataset = GUI.session.getregisterable(indexes(iDataset));
            
            
            modality = thisDataset.label;
            id = thisDataset.matlabId;
            
            
            
            string = sprintf('%s (%s)',modality,id);
            
            GUI.handles(4).(['chckbox',num2str(iDataset)]) = uicontrol('style','checkbox',...
                'units','pix',...
                'position',[20,470 - 20*iDataset,200,20],...
                'visible','off',...
                'String',string,...
                'callback',{@w4_addDataset,iDataset});
            
        end
        GUI.rootdatasetSelect = zeros(GUI.nDatasets,1);
        
end
guidata(hObject,GUI);




%w1 functions

function [] = w1_next(varargin)
% Callback for pushbutton, deletes one line from listbox.
next(1,varargin{1})

function [] = w2_next(varargin)
GUI = guidata(varargin{1});
next(2,varargin{1})



function [] = w1_browse(varargin)
GUI = guidata(varargin{1});

%get file
S = Session;
[filename,directory] = uigetfile('*.dcm');
GUI.input.filename = filename;
GUI.input.directory = directory;

%load file
set(gcf,'Pointer','watch');
set(GUI.handles(1).details,'string','Unpacking session. Please wait..')
S.loadzip(fullfile(directory,filename))

% add session to GUI
GUI.session = S;

%print data
nVNAs = numel(GUI.session.therapyPlanStorage);

[~,types] = GUI.session.listregisterables;
nDatasets = numel(find(ismember(types,'Dataset')));
nIBS = numel(find(ismember(types,'ImageBasedStructureSegmentation')));
nMBS = numel(find(ismember(types,'ManualStructureSegmentation')));
nAtlases = numel(find(ismember(types,'Atlas')));

GUI.nVNAs = nVNAs;
GUI.nIBS = nIBS;
GUI.nMBS = nMBS;
GUI.nAtlases = nAtlases;
GUI.nDatasets = nDatasets;


set(GUI.handles(1).details,'string',sprintf('Session has been loaded.\nVNAs:\t %d\nInstensity Based segmentations:\t %d\nManual Segmentations:\t %d\nDatasets:\t %d\nAtlases:\t %d',nVNAs,nIBS,nMBS,nDatasets,nAtlases))

set(gcf,'Pointer','arrow');
set(GUI.handles(1).pbnext,'enable','on')

guidata(varargin{1},GUI)



%w2

function w2_addVNA(hObject,eventData,checkBoxId)
GUI = guidata(hObject);
GUI.vnaSelect(checkBoxId) = get(hObject,'Value');

if any(GUI.vnaSelect);
    set(GUI.handles(2).pbnext,'enable','on')
else
    set(GUI.handles(2).pbnext,'enable','off')
end
guidata(hObject,GUI);

function w2_VNAlistbox(hObject,eventData,handles)
GUI = guidata(hObject);
items = get(hObject,'String');
index_selected = get(hObject,'Value');
if numel(index_selected)>0
    set(GUI.handles(2).VNAcheckbox,'Value',1)
end

function w2_Atlaslistbox(hObject,eventData,handles)
GUI = guidata(hObject);
items = get(hObject,'String');
index_selected = get(hObject,'Value');
if numel(index_selected)>0
    set(GUI.handles(2).atlascheckbox,'Value',1)
end


function w2_deselectatlas(hObject,eventData,handles)
GUI = guidata(hObject);
switch get(hObject,'Value')
    case 0
        set(GUI.handles(2).listboxAtlas,'Value',[])
end

function w2_IBSlistbox(hObject,eventData,handles)
GUI = guidata(hObject);
items = get(hObject,'String');
index_selected = get(hObject,'Value');
if numel(index_selected)>0
    set(GUI.handles(2).IBScheckbox,'Value',1)
end



function w2_MBSlistbox(hObject,eventData,handles)
GUI = guidata(hObject);
items = get(hObject,'String');
index_selected = get(hObject,'Value');
if numel(index_selected)>0
    set(GUI.handles(2).MBScheckbox,'Value',1)
end


function w2_deselectVNA(hObject,eventData,handles)
GUI = guidata(hObject);
switch get(hObject,'Value')
    case 0
        set(GUI.handles(2).listboxVNA,'Value',[])
end

function w2_deselectIBS(hObject,eventData,handles)
GUI = guidata(hObject);
switch get(hObject,'Value')
    case 0
        set(GUI.handles(2).listboxIBS,'Value',[])
end

function w2_deselectMBS(hObject,eventData,handles)
GUI = guidata(hObject);
switch get(hObject,'Value')
    case 0
        set(GUI.handles(2).listboxMBS,'Value',[])
end


%w3

function w3_next(varargin)
next(3,varargin{1})




function w3_addDataset(hObject,eventData,checkBoxId)
GUI = guidata(hObject);
GUI.datasetSelect(checkBoxId) = get(hObject,'Value');

if any(GUI.datasetSelect)
    set(GUI.handles(3).pbnext,'enable','on')
else
    set(GUI.handles(3).pbnext,'enable','on') %historic 
end
guidata(hObject,GUI);


%w4
function w4_addDataset(hObject,eventData,checkBoxId)
GUI = guidata(hObject);
GUI.rootdatasetSelect(checkBoxId) = get(hObject,'Value');

if sum(GUI.rootdatasetSelect)==1
    set(GUI.handles(4).pbnext,'enable','on')
else
    set(GUI.handles(4).pbnext,'enable','off')
end
guidata(hObject,GUI);

function w4_next(varargin)
next(4,varargin{1})


%w5

function [] = w5_browse(varargin)
GUI = guidata(varargin{1});

GUI.outputFolder = uigetdir();


%         set(GUI.handles(1).details,'string',sprintf('Session has been loaded.\nVNAs:\t %d\nDatasets:\t %d',nVNAs,nDatasets))

%         GUI.session.get




set(GUI.handles(5).pbcompute,'enable','on')
set(GUI.handles(5).details,'string',sprintf('Press compute to export nifti files to:\n%s',GUI.outputFolder))
guidata(varargin{1},GUI)


function [] = w5_compute(varargin)
GUI = guidata(varargin{1});

try
settings_spm = load(fullfile(fileparts(mfilename('fullpath')),'settings_spm.mat'));
SPM12folder = settings_spm.folder;
catch
    waitfor(msgbox('Looks like you run this tool for the first time. Can you find the SPM folder for me?'))
    folder = uigetdir('','Find SPM folder');
    save(fullfile(fileparts(mfilename('fullpath')),'settings_spm.mat'),'folder')
    SPM12folder = folder;
end

% get all dataset Id's
[allnames,alltypes] = GUI.session.listregisterables;
DatasetIndices = find(ismember(alltypes,'Dataset'));
datasetnames = allnames(DatasetIndices);
burninDatasets = datasetnames(logical(GUI.datasetSelect));
rootdatasetname = datasetnames{logical(GUI.rootdatasetSelect)};
rootdataset = GUI.session.getregisterable(rootdatasetname);
root_backupvoxelarray = rootdataset.volume.voxelArray;
root_backupvolumeinfo = rootdataset.volume.volumeInfo;

%get all shape indices
VNAs = GUI.handles(2).listboxVNA.Value;
Atlases = GUI.handles(2).listboxAtlas.Value;
IBSs = GUI.handles(2).listboxIBS.Value;
MBSs = GUI.handles(2).listboxMBS.Value;

% number of total iterations
nOutputFiles = (numel(burninDatasets)+1)*(numel(VNAs)+numel(Atlases)+numel(IBSs)+numel(MBSs));
box on


%make output folders
rootdir = fullfile(GUI.outputFolder,GUI.input.filename(1:end-4),'root');
objectdir = fullfile(GUI.outputFolder,GUI.input.filename(1:end-4),'objects');
mkdir(rootdir);
mkdir(objectdir);



counter = 0;
axes(GUI.handles(5).waitbaraxes)
cd(GUI.outputFolder)
for iDataset = 1:numel(burninDatasets)+1
    if iDataset > numel(burninDatasets) %SPM dataset
        
        rootdatasetname = datasetnames{logical(GUI.rootdatasetSelect)};
        rootdataset = GUI.session.getregisterable(rootdatasetname);
        rootdataset.volume.voxelArray = root_backupvoxelarray; %these were overwritten
        rootdataset.volume.volumeInfo = root_backupvolumeinfo; % these were overwritten

        %increase rootdataset to highres
        Highres = rootdataset.volume.volumeInfo;
        Highres.spacing = [0.5 0.5 0.5];
        Highres.dimensions = ceil(rootdataset.volume.volumeInfo.dimensions .* rootdataset.volume.volumeInfo.spacing./Highres.spacing);
        target.volume.volumeInfo = Highres; %"target" is a new highres space
        highresvoxels = resliceDataset(rootdataset,target, eye(4));

        %make a highres "Volume" to run exportnifti
        Vroot = Volume;
        Vroot.voxelArray = highresvoxels;
        Vroot.volumeInfo = Highres;
        Vroot.linktosession(GUI.session); %in order to suppress warning.

        sourceDir = fullfile(rootdir,'native.nii');
        otherDir = {[sourceDir,',1']};
        Vroot.exportnifti(sourceDir);
        
        datasetname = rootdatasetname;
        thisDataset = rootdataset;
        thisDataset.volume = Vroot;
        modality = 'highres';
        thisVolume = Vroot;
        SPM = 1;

    else %Burn in Dataset
        datasetname = burninDatasets{iDataset};
        thisDataset = GUI.session.getregisterable(datasetname);
        modality = thisDataset.label;
        thisVolume = thisDataset.volume;
        dirname = fullfile(objectdir,modality);
        thisVolume.exportnifti(dirname);
        SPM = 0;
    end
    
    %export VNAs
    for iVNA = 1:numel(VNAs)
        thisVNA = GUI.session.therapyPlanStorage{VNAs(iVNA)};
        counter = counter+1;
        
        
        vnalabel = thisVNA.label;
        vnaamp = num2str(thisVNA.stimulationValue);
        vnarings = thisVNA.activeRings;
        vnaname = sprintf('%s: %s (%s)',vnalabel,vnaamp,vnarings);
        
        % print text to GUI
        GUIstring = sprintf('Making: %s --> %s',vnaname,datasetname);
        % update waitbar
        set(GUI.handles(5).details,'string',GUIstring)
        
        
        cla
        rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','b');
        text(482,10,[num2str(round(100*counter/nOutputFiles)),'%']);
        
        drawnow()
        
        %Get the Transformationmatrix of the VTA to root
        lead = thisVNA.lead;
        T = GUI.session.gettransformfromto(lead,rootdataset);
        voxelarray  = resliceDataset(thisVNA.vta.Medium,thisDataset, T);
        thisVolume.voxelArray = voxelarray;
        thisfilename = fullfile(objectdir,[lead.label,'_',thisVNA.label,'_',modality,'.nii']);
        thisfilename = strrep(thisfilename,' ','_');
        thisVolume.exportnifti(thisfilename)
        
        %Update SPM file list
        if SPM
            otherDir{end+1} = [thisfilename,',1'];
        end
        
    end
    
    %export IBSs
    for iIBS = 1:numel(IBSs)
        
        %get all registerables
        [allnames,alltypes] = GUI.session.listregisterables;
        
        % get list with only IBS
        IBSIndices = find(ismember(alltypes,'ImageBasedStructureSegmentation'));
        
        %get thisIBS
        thisIBS = GUI.session.getregisterable(allnames{IBSIndices(iIBS)});
        
        
        
        %print text and waitbar
        label= strrep(thisIBS.label,' ','_');
        objname = sprintf('%Intensity based segmentation: %s',label);
        datasetname= burninDatasets{iDataset};
        GUIstring = sprintf('Making: %s --> %s',objname,datasetname);
        set(GUI.handles(4).details,'string',GUIstring)
        
        % update waitbar
        counter = counter+1;
        
        cla
        rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','b');
        text(482,10,[num2str(round(100*counter/nOutputFiles)),'%']);
        drawnow()
        
        %Call the function
        voxelarray = u_unpackmesh(GUI.session, datasetname,thisIBS);
        modality = GUI.session.getregisterable(datasetname).label;
        filename = [GUI.session.patient.name,'_',modality,'_IntensityBasedSeg_',thisIBS.label,'.nii'];
        filename = strrep(filename,' ','_');
        
        thisVolume.voxelArray = voxelarray;
        thisfilename = fullfile(objectdir,[IntensityBasedSeg_',thisIBS.label,'_',modality,'.nii']);
        thisfilename = strrep(thisfilename,' ','_');
        thisVolume.exportnifti(thisfilename)
        
        %Update SPM file list
        if SPM
            otherDir{end+1} = [thisfilename,',1'];
        end
        
        
        
    end
    
    %export MBSs
    for iMBS = 1:numel(MBSs)
        
        %get all registerables
        [allnames,alltypes] = GUI.session.listregisterables;
        
        % get list with only IBS
        MBSIndices = find(ismember(alltypes,'ManualStructureSegmentation'));
        
        %get thisIBS
        thisMBS = GUI.session.getregisterable(allnames{MBSIndices(iMBS)});
        
        
        %print text and waitbar
        label= strrep(thisMBS.label,' ','_');
        objname = sprintf('%Manual segmentation: %s',label);
        datasetname= burninDatasets{iDataset};
        GUIstring = sprintf('Making: %s --> %s',objname,datasetname);
        set(GUI.handles(4).details,'string',GUIstring)
        
        % update waitbar
        counter = counter+1;
        
        cla
        rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','b');
        text(482,10,[num2str(round(100*counter/nOutputFiles)),'%']);
        drawnow()
        
        %Call the function
        voxelarray = u_unpackmesh(GUI.session, datasetname,thisMBS);
        modality = GUI.session.getregisterable(datasetname).label;
        
        thisVolume.voxelArray = voxelarray;
        thisfilename = fullfile(objectdir,['IntensityBasedSeg_',thisMBS.label,'_',modality,'.nii']);
        thisfilename = strrep(thisfilename,' ','_');
        thisVolume.exportnifti(thisfilename)
        
        %Update SPM file list
        if SPM
            otherDir{end+1} = [thisfilename,',1'];
        end
        
        
    end
    
    %export MBSs
    for iAtlas = 1:numel(Atlases)
        
        %get all registerables
        [allnames,alltypes] = GUI.session.listregisterables;
        
        % get list with only IBS
        AtlasIndices = find(ismember(alltypes,'Atlas'));
        
        %get thisIBS
        thisAtlas = GUI.session.getregisterable(allnames{AtlasIndices(iAtlas)});
        
        
        %print text and waitbar
        label= strrep([thisAtlas.group,thisAtlas.hemisphere],' ','_');
        objname = sprintf('%Atlas: %s',label);
        GUIstring = sprintf('Making: %s --> %s',objname,datasetname);
        set(GUI.handles(4).details,'string',GUIstring)
        
        % update waitbar
        counter = counter+1;
        cla
        rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','b');
        text(482,10,[num2str(round(100*counter/nOutputFiles)),'%']);
        drawnow()
        
        %Call the function
        switch thisAtlas.group
            case 'Stn'
                atlasfiles = {'LH_STN-ON-pmMR.obj',...
                    'LH_RU-ON-pmMR.obj',...
                    'LH_SN-ON-pmMR.obj'};
                atlasnames = {'STN','RN','SN'};
            case 'Gpi'
                atlasfiles = {'LH_EGP-ON-pmMR.obj',...
                    'LH_IGP-ON-pmMR.obj'};
                atlasnames = {'GPe','GPi'};
        end
        
        for iStructure = 1:numel(atlasnames)
            thisStructure = ObjFile(atlasfiles{iStructure});
            thisStructure = thisStructure.transform(GUI.session.gettransformfromto(thisAtlas,datasetname));
            voxelarray = u_unpackmesh(GUI.session, datasetname,thisStructure);
            modality = GUI.session.getregisterable(datasetname).label;

            thisVolume.voxelArray = voxelarray;
            thisfilename = fullfile(objectdir,['Atlas_',atlasnames{iStructure},thisAtlas.hemisphere,'_',modality,'.nii']);
            thisfilename = strrep(thisfilename,' ','_');
            thisVolume.exportnifti(thisfilename)

            %Update SPM file list
            if SPM
                otherDir{end+1} = [thisfilename,',1'];
            end
        end
        
    end
    
    
    
    
    
end

disp('Note: SPM will start shortly')
disp('This may take a couple of minutes. It will say when it''s ready')

matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol ={[sourceDir,',1']};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = otherDir';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {fullfile(SPM12folder,'tpm/TPM.nii')};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70; 78 76 85];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [0.5 0.5 0.5];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'mni_';


 spm_jobman('run', matlabbatch);
 
 

rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','g');
text(482,10,'Done');
set(GUI.handles(4).details,'string','You may now close this window')
otherDir










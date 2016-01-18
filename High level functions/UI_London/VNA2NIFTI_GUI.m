function [  ] = VNA2NIFTI_GUI(  )
%GUI Summary of this function goes here
%   Detailed explanation goes here


GUI.fh = figure('Units','pixels',...
    'position',[500 500 400 500],...
    'menubar','none',...
    'name','GUI_1',...
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
            
GUI.handles(2).IBScheckbox = uicontrol('style','checkbox',...
                    'units','pix',...
                    'position',[20,300,200,20],...
                    'horizontalAlignment','left',...
                    'visible','off',...
                    'Value',0,...
                    'callback',{@w2_deselectIBS},...
                    'String','Intensity based segmentations:');                
               
                
GUI.handles(2).listboxIBS = uicontrol('style','listbox',...
                'units','pix',...
                'position',[20,200,360, 100],...
                'visible','off',...
                'max',1000,...
                'min',0,...
                'value',[],...
                'callback',{@w2_IBSlistbox},...
                'enable','on'); 
            
            
GUI.handles(2).MBScheckbox = uicontrol('style','checkbox',...
                    'units','pix',...
                    'position',[20,160,200,20],...
                    'horizontalAlignment','left',...
                    'visible','off',...
                    'Value',0,...
                    'callback',{@w2_deselectMBS},...                    
                    'String','Manual Segmentations:');                
                
                
                
GUI.handles(2).listboxMBS = uicontrol('style','listbox',...
                'units','pix',...
                'position',[20,60,360, 100],...
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
                 'enable','off');  
             
%window 4

GUI.handles(4).pbcompute = uicontrol('style','push',...
                 'units','pix',...
                 'position',[210 10 180 40],...
                 'fontsize',12,...
                 'string','Compute',...
                 'visible','off',...
                 'enable','off');
             
GUI.handles(4).text = uicontrol('style','text',...
                    'units','pix',...
                    'position',[20,470,200,20],...
                    'horizontalAlignment','left',...
                    'visible','off',...
                    'String','Select output folder...');
                
GUI.handles(4).pbbrowse = uicontrol('style','push',...
                 'units','pix',...
                 'position',[20 440 60 30],...
                 'fontsize',10,...
                 'string','Browse',...
                 'visible','off',...
                 'enable','on');
             
GUI.handles(4).details = uicontrol('style','text',...
                    'units','pix',...
                    'position',[20,180,480,250],...
                    'HorizontalAlignment','left',...
                    'visible','off',...
                    'String',sprintf(''));
                
GUI.handles(4).waitbaraxes = axes('Units','pix',...
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
set(GUI.handles(4).pbbrowse,'callback',{@w4_browse,GUI})
set(GUI.handles(4).pbcompute,'callback',{@w4_compute,GUI})




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
                GUI.datasetSelect = zeros(GUI.nVNAs,1);
            
    end
    guidata(hObject,GUI);


    

    %w1 functions
             
function [] = w1_next(varargin)
    % Callback for pushbutton, deletes one line from listbox.
    disp('click')
    next(1,varargin{1})
    
function [] = w2_next(varargin)
    GUI = guidata(varargin{1});
    next(2,varargin{1})
    disp('sadf')

        

function [] = w1_browse(varargin)
        GUI = guidata(varargin{1});
        
        %get file
        S = Session;
        [filename,directory] = uigetfile('*.dcm');
        cd(directory)
        
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
        
        GUI.nVNAs = nVNAs;
        GUI.nIBS = nIBS;
        GUI.nMBS = nMBS;
        GUI.nDatasets = nDatasets;
        
        set(GUI.handles(1).details,'string',sprintf('Session has been loaded.\nVNAs:\t %d\nInstensity Based segmentations:\t %d\nManual Segmentations:\t %d\nDatasets:\t %d',nVNAs,nIBS,nMBS,nDatasets))
               
        set(gcf,'Pointer','arrow');
        set(GUI.handles(1).pbnext,'enable','on')
        
        disp('browse')
        
        
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
    
    if any(GUI.datasetSelect);
        set(GUI.handles(3).pbnext,'enable','on')
    else
        set(GUI.handles(3).pbnext,'enable','off')
    end
    guidata(hObject,GUI);
         
    
%w4

function [] = w4_browse(varargin)
        GUI = guidata(varargin{1});
        
         GUI.outputFolder = uigetdir();
        
        
%         set(GUI.handles(1).details,'string',sprintf('Session has been loaded.\nVNAs:\t %d\nDatasets:\t %d',nVNAs,nDatasets))
        
%         GUI.session.get       
        
        
        
              
        set(GUI.handles(4).pbcompute,'enable','on')
        set(GUI.handles(4).details,'string',sprintf('Press compute to export nifti files to:\n%s',GUI.outputFolder))
        guidata(varargin{1},GUI)
       
        
    function [] = w4_compute(varargin)
        GUI = guidata(varargin{1});
        
        % get all dataset Id's
        [allnames,alltypes] = GUI.session.listregisterables;
        DatasetIndices = find(ismember(alltypes,'Dataset'));
        datasetnames = allnames(DatasetIndices);
        outputDatasets = datasetnames(logical(GUI.datasetSelect));
        
        
        %get all shape indices
        VNAs = GUI.handles(2).listboxVNA.Value;
        IBSs = GUI.handles(2).listboxIBS.Value;
        MBSs = GUI.handles(2).listboxMBS.Value;
        
        % number of total iterations
        nOutputFiles = numel(outputDatasets)*(numel(VNAs)+numel(IBSs)+numel(MBSs));
        box on
        
        counter = 0;
        axes(GUI.handles(4).waitbaraxes)
        cd(GUI.outputFolder)
        for iDataset = 1:numel(outputDatasets)
            %export VNAs
            for iVNA = 1:numel(VNAs)
                thisVNA = GUI.session.therapyPlanStorage{VNAs(iVNA)};
                counter = counter+1;
                datasetname= outputDatasets{iDataset};
                modality = GUI.session.getregisterable(datasetname).label;
                
                
                
                vnalabel = thisVNA.label;
                vnaamp = num2str(thisVNA.stimulationValue);
                vnarings = thisVNA.activeRings;
                vnaname = sprintf('%s: %s (%s)',vnalabel,vnaamp,vnarings);
                
                % print text to GUI
                GUIstring = sprintf('Making: %s --> %s',vnaname,datasetname);
                % update waitbar
                set(GUI.handles(4).details,'string',GUIstring)
                
                
                
                
                cla
                rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','b');
                text(482,10,[num2str(round(100*counter/nOutputFiles)),'%']);
                
                drawnow()
                
                %Call the function
                nii = voxeliseVNA(GUI.session, datasetname,thisVNA);
                nii.hdr.intent_narnme = [modality,'_',vnalabel];
                
                
                filename = [GUI.session.patient.name,'_',modality,'_',thisVNA.lead.label,'_',vnalabel,'_',vnaamp,'_',vnarings,'.nii'];
                filename = strrep(filename,' ','_'); 
                %save the niftii
                 save_nii(nii, filename)
                 
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
                datasetname= outputDatasets{iDataset};
                GUIstring = sprintf('Making: %s --> %s',objname,datasetname);
                set(GUI.handles(4).details,'string',GUIstring)
                
                % update waitbar
                counter = counter+1;
                
                cla
                rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','b');
                text(482,10,[num2str(round(100*counter/nOutputFiles)),'%']);
                drawnow()
                
                %Call the function
                nii = voxeliseMESH(GUI.session, datasetname,thisIBS);               
                modality = GUI.session.getregisterable(datasetname).label;
                filename = [GUI.session.patient.name,'_',modality,'_IntensityBasedSeg_',thisIBS.label,'.nii'];
                filename = strrep(filename,' ','_'); 
                %save the niftii
                 save_nii(nii, filename)
                 
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
                datasetname= outputDatasets{iDataset};
                GUIstring = sprintf('Making: %s --> %s',objname,datasetname);
                set(GUI.handles(4).details,'string',GUIstring)
                
                % update waitbar
                counter = counter+1;
                
                cla
                rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','b');
                text(482,10,[num2str(round(100*counter/nOutputFiles)),'%']);
                drawnow()
                
                %Call the function
                nii = voxeliseMESH(GUI.session, datasetname,thisMBS);               
                modality = GUI.session.getregisterable(datasetname).label;
                filename = [GUI.session.patient.name,'_',modality,'_ManualSeg_',thisMBS.label,'.nii'];
                filename = strrep(filename,' ','_'); 
                %save the niftii
                 save_nii(nii, filename)
                 
            end                  
            
            
            rectangle('Position',[0,0,(round(1000*counter/nOutputFiles))+1,20],'FaceColor','g');
             text(482,10,'Done');
             set(GUI.handles(4).details,'string','You may now close this window')
            
            
        end
                
        
        
        
        
        
        
        
        
        
    

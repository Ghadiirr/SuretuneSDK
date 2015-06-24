classdef Session < handle_hidden
    % SESSION   A session object relates to exactly one SureTune2 session.
    % A Session contains the raw SureTune data:
    %   - Session Data (XML)
    %   - Meshes (OBJ)
    %   - Volumes (bin)
    %
    % This toolbox processes the raw Session Data into:
    % A tree of Registerables, containing:
    %   - DATASET
    %       > Refers to a Volume instance describing the imagevolume
    %   - Path
    %   - ACPCIH
    %   - Lead
    %   - ImageBasedStructureSegmentation
    %   - ManualStructureSegmentation
    %   - ImportedStructure (with ImportedMeshPart)
    %       > MeshPart refers to an OBJ instance describing the mesh
    %   - Stf
    %   - StimPlan
    %       > Refers to a Volume Instance describing the VTA
    %
    %
    
    
    
    properties (Hidden = true)  %These properties are hidden to not bother the user.
        originalSessionData %The original XML file
        directory %Directory of the loaded XML file
        log %Changes are logged
        %         ActiveSession = 1;
                activeDataset = 1;
        registerables %List of all Registerables
        master %Registerable tree starts with this dataset
        noLog = 0; %Flag if logging is done
        sureTune = 'C:\GIT\SureSuite\Output\';% Folder where SureTune is installed 'C:\Suresuit\Blue3\' %
        exportFolder = 'C:\MATLAB-Addons\Export\'; % Folder were sessions are exported.
        
    end
    
    properties
        sessionData %Imported SureTune2Session.xm
        volumeStorage %list that contains all Volume Objects (the actual voxeldata)
        meshStorage %list that contains all Mesh Objects (the actual faces and vertices)
        therapyPlanStorage %TBD
    end
    
    methods(Hidden = true)  %These methods are hidden because they are called from within.
        
        
        function addtolog(obj,varargin)
            % varargin should be a cell array with strings
            if obj.noLog;return;end;
            obj.log{end+1,1} = datestr(datetime);
            fprintf(['\n',sprintf(varargin{:}),'\n']);
            obj.log{end,2} = sprintf(varargin{:});
        end
        
        
        function ok = checkinputarguments(obj,nargin,n,type)
            % Check if the number of input arguments is correct
            switch type
                case 'Registerable'
                    if nargin ~= n+1 %+1 = objectt
                        warningtxt = ['Specifiy ',num2str(n),sprintf(' Registerable(s): \n\t  - '),strjoin(obj.listregisterables,'\n\t  - ')];
                        ok = 0;  %#ok<NASGU>
                        error(warningtxt)
                    else ok = 1;
                    end
            end
        end
        
        
    end
    
    methods
        
        
        function obj = Session(varargin)
            % Constructor. No input is required. Creates an empty Session
            % Instance
            
            if nargin > 0
                warning('No input arguments are required. Run loadXML to populate session objects.')
            end
            
            % Add empty cells:
            obj.volumeStorage.list = {};
            obj.volumeStorage.names = {};
            obj.therapyPlanStorage.list = {};
            obj.therapyPlanStorage.names = {};
            obj.meshStorage.list = {};
            obj.meshStorage.names = {};
            
            % Make export dir of not already exist:
            if ~exist(obj.exportFolder,'dir')
                mkdir(obj.exportFolder);
            end
        end
        
        
        
        function loadxml(obj,pathName,fileName)
            % Input should be pathname and filename, otherwise a dialog
            % appears.
            
            if nargin == 1 %No input -> therefore dialog box
                [fileName,pathName] = uigetfile('.xml');
                if ~fileName
                    disp('Aborted by user');return
                end
            elseif nargin~=3
                error('Invalid Input')
            end
            
            %load xml
            loadedXml = SDK_xml2struct([pathName,fileName]);
            
            % Check for any comments (they may obstruct XML parsing)
            if SDK_removecomments(pathName,fileName);
                
                % Comments have been removed. Load session:
                fileName = [fileName(1:end-4),'_nocomments',fileName(end-3:end)];
                loadedXml = SDK_xml2struct([pathName,fileName]);
            end
            
            % Check if there is only one Session. Otherwise throw warning.
            [loadedXml,abort] = SDK_hasmultiplesessions(loadedXml, pathName,fileName);
            if abort;return;end
            
            
            %add properties to object
            obj.originalSessionData = loadedXml;
            obj.sessionData = loadedXml;
            obj.log = {datestr(datetime),['Load file:',pathName,fileName]};
            obj.directory = pathName;
            
            %print session Info
            obj.sessioninfo();
            
            %set flag
            obj.activeDataset = 1;
            
            %find registerables
            obj.noLog = 1;
            obj.registerables = SDK_findregistrables(obj);
            obj.noLog = 0;
            %             O.Master = O.SessionData.
        end
        
        
        
        
        function loadzip(obj,file)
            
            %get PathName
            if nargin==1;
                [fileName,pathName] = uigetfile('.zip');
                if not(fileName)
                    disp('Aborted by user')
                    return
                end
                file = [pathName,fileName];
            end
            
            
            %Unzip
            eval(['!C:/MATLAB-Addons/SDK/7za.exe x -bd -y ',file,' -o',file(1:end-4)]);
            
            %Index Volumes
            obj.volumeStorage = obj.loadvolumes([file(1:end-4),'\Volumes']);
            
            %Load Meshes
            obj.meshStorage = obj.loadmeshes([file(1:end-4),'\Meshes']);
            
            %Load XML
            obj.loadxml([file(1:end-4),'\'],'SureTune2Sessions.xml')
            
            %Load Stimplans
            obj.therapyPlanStorage = obj.loadtherapyplans(file(1:end-4));
            
            
            
        end
        
        
        
        function planArrayOutput = loadtherapyplans(obj,sessiondir)
            thisdir = pwd;
            planArrayOutput = {};
            
            % Browse to therapy folders:
            cd(sessiondir)
            cd('Sessions')
            
            if exist(obj.getsessionname(),'dir')
                cd(obj.getsessionname());
            else
                disp('No TherapyPlans for this session')
                cd(thisdir)
                return;
            end
            
            if exist([pwd,'/Leads'],'dir')
                cd('Leads')
            else
                disp('No TherapyPlans for this session');
                cd(thisdir)
                return;
            end
                
                
                
              
                leadFolders = SDK_subfolders('');
                
                % For all leads find the therapy plans:
                for iSubFolder = 1:numel(leadFolders)
                    thisLead = leadFolders{iSubFolder};
                    
                    %find thislead in the sessiondata
                    [names,types] = obj.listregisterables;
                    leadNames = names(ismember(types,'Lead'));
                    
                    %Find Lead Object
                    leadObject = obj.getregisterable(leadNames{~cellfun(@isempty,strfind(leadNames,thisLead))});
                    
                    
                    therapyPlanFolders = SDK_subfolders(thisLead);
                    
                    %For all therapy plans make a Therapy Object.
                    for iTherapyPlanFolder = 1:numel(therapyPlanFolders)
                        thisPlan = therapyPlanFolders{iTherapyPlanFolder};
                        
                        %Find the corresponding SessionData, using the lead
                        %name and therapyplanname
                        obj = leadObject.session;
                        xmlPath = leadObject.path;
                        therapyXml = eval(xmlPath);
                        
                        %there may be multiple stimplans in the session data,
                        %find the correct one.
                        stimPlanIndex = 0;
                        for iStimPlan = 1:numel(therapyXml.stimPlans.Array.StimPlan)
                            if strcmp(therapyXml.stimPlans.Array.StimPlan{iStimPlan}.label.Attributes.value,thisPlan)
                                stimPlanIndex = iStimPlan;
                                continue;
                            end
                        end
                        if stimPlanIndex==0;warning(['No matching stimplan in SessionData for ',thisPlan]);return;end
                        
   
                        % Get the Stimplan data from therapyXML:
                        VTA = obj.loadvolumes([thisLead,'\',thisPlan]);
                        label = thisPlan;
                        voltageBasedStimulation = therapyXml.stimPlans.Array.StimPlan{stimPlanIndex}.voltageBasedStimulation.Attributes.value;
                        stimulationValue = str2double(therapyXml.stimPlans.Array.StimPlan{stimPlanIndex}.stimulationValue.Attributes.value);
                        pulseWidth = str2double(therapyXml.stimPlans.Array.StimPlan{stimPlanIndex}.pulseWidth.Attributes.value);
                        pulseFrequency =str2double(therapyXml.stimPlans.Array.StimPlan{stimPlanIndex}.pulseFrequency.Attributes.value);
                        activeRings = therapyXml.stimPlans.Array.StimPlan{stimPlanIndex}.activeRings.BoolArray.Text;
                        contactsGrounded = therapyXml.stimPlans.Array.StimPlan{stimPlanIndex}.contactsGrounded.BoolArray.Text;
                        annotation = therapyXml.stimPlans.Array.StimPlan{stimPlanIndex}.annotation.Attributes.value;
                        
                        % Make a StimPlan Instance:
                        stimPlanObject = StimPlan(VTA,leadObject,label,voltageBasedStimulation,stimulationValue,pulseWidth,pulseFrequency,activeRings,contactsGrounded,annotation);
                        
                        %Add the therapy object to Lead.StimPlan{end+1}
                        leadObject.stimPlan{end+1} = stimPlanObject;
                        planArrayOutput{end+1} = stimPlanObject; %#ok<AGROW>
                    end
                end
                
                % Revert to original directory: 
                cd(thisdir)
            end
            
            
            
            function meshArrayOutput = loadmeshes(thisSession,folder)
                thisdir = pwd;
                cd(folder)
                
                % Initialize output:
                meshArrayOutput.list = {};
                meshArrayOutput.names = {};
                
                % Get a list with all obj filenames:
                objFiles = dir('*.obj');
                objNames ={objFiles.name};
                
                
                for iObjName = 1:numel(objNames)
                    if ~iscell(objNames)
                        fileName = objNames;
                    else
                        fileName = objNames{iObjName};
                    end
                    
                    %Read the OBJ file
                    [V,F] = SDK_obj2fv(fileName);
                    
                    
                    %Add an Obj instance to the list.
                    meshArrayOutput.list{iObjName} = Obj(V,F,fileName);
                    meshArrayOutput.list{iObjName}.linktosession(thisSession)
                    
                    %Add the name to the list.
                    meshArrayOutput.names{iObjName} = fileName;
                    
                    if ~iscell(objNames)
                        break
                    end
                    
                end
                
                % Revert to original directory
                cd(thisdir)
                
            end
            
            function volumeArrayOutput = loadvolumes(thisSession,folder)
                thisDir = pwd;
                cd(folder)
                
                %get a list with all obj files
                volumeArrayOutput.list = {};
                volumeArrayOutput.names = {};
                
                volumeFolders = SDK_subfolders();
                
                for iVolumeFolder = 1:numel(volumeFolders)
                    %Add an Volume instance to the list.
                    volumeObject = Volume();
                    volumeObject.loadvolume(volumeFolders{iVolumeFolder});
                    volumeObject.linktosession(thisSession);
                    
                    volumeArrayOutput.list{iVolumeFolder} = volumeObject;
                    volumeArrayOutput.names{iVolumeFolder} = volumeFolders{iVolumeFolder};
                end
                % Revert to original directory
                cd(thisDir)
                
            end
            
            function import2suretune(obj)
                disp('Saving Files...')
                
                if isempty(obj.directory)
                    warning('No Session was loaded')
                    return
                end
                
                thisdir = pwd;
                cd(obj.directory)
                
                
                % Save Sessions:
                SDK_session2xml(obj.sessionData,'SureTune2Sessions.xml')
                SDK_session2xml(obj.originalSessionData,'OriginalSession.xml')
                
                % Save Meshes:
                for iMesh = 1:numel(obj.meshStorage.list);
                    obj.meshStorage.list{iMesh}.savetofolder('Meshes')
                    
                    % Also save the mesh to meshstorage:
                    vertface2obj( obj.meshStorage.list{iMesh}.v, obj.meshStorage.list{iMesh}.f,[obj.sureTune,'MeshStorage/',obj.meshStorage.list{iMesh}.fileName])
                end
                
                % Save new Volumes
                for iVolume = 1:numel(obj.volumeStorage.list);
                    
                    obj.volumeStorage.list{iVolume}.savetofolder(['Volumes/',obj.volumeStorage.names{iVolume}]);
                end
                
                % Export log
                table = cell2table(obj.log,'VariableNames',{'datetime','action'});
                writetable(table,[obj.directory,'/Log.txt'],'Delimiter','\t')
                
                % Zip session:
                disp('Zipping Session...')
                eval('!C:/MATLAB-Addons/SDK/7za.exe a -tzip -r -bd -- session.zip '); %-xr@Log.txt -xr@OriginalSession.xml
                
                
                %Import
                disp('Importing Session To SureTune')
                cd(obj.sureTune)
                fclose all;
                eval(['!SureplanArchive.exe /noencryption /importsessions ',obj.directory,'session.zip'])
                cd(thisdir)
                
            end
            
            
            function importfromsuretune(obj, wildcard)
                
                if nargin==1
                    disp('input arguments: wildcard')
                    disp('wildcard: ''*01*'' to filter on filenames that contain 01')
                    return
                end
                thisdir = pwd;
                
                fileName = 'MATLABinput.zip';
                
                % Browse to SureTune folder:
                cd(obj.sureTune)
                if exist(fileName,'file');delete(fileName);end               
                if exist('MATLABinput','dir');rmdir('MATLABinput','s');end 
                eval(['!SureplanArchive.exe /noencryption /patientname "',wildcard,'" /exportsessions ',fileName])
                
                obj.loadzip([obj.sureTune,fileName])
                
                %Revert to original directory
                cd(thisdir)
            end
            
            
            
            
            function savesession(obj)
                [folder] = uigetdir(pwd,'Select directory to save Session');
                
                
                SDK_session2xml(obj.sessionData,[folder,'/Session.xml'])
                SDK_session2xml(obj.originalSessionData,[folder,'/OriginalSession.xml'])
                
                %export log
                table = cell2table(obj.log,'VariableNames',{'datetime','action'});
                writetable(table,[folder,'/Log.txt'],'Delimiter','\t')
                
                
            end
            
            
            %% Logging
            
            
            function getlog(obj)
                transposed = transpose(obj.log);
                fprintf('%s\t%s\n',transposed{:})
                
            end
            
            
            
            %% Sessions
            
            function sessioninfo(obj)
                sessionname = obj.sessionData.SureTune2Sessions.Session.id.Attributes.value;
                patientname = obj.sessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value;
                dateofbirth = obj.sessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value;
                gender = obj.sessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value;
                savedate = obj.sessionData.SureTune2Sessions.Attributes.exportDate;
                
                fprintf('Session info\n-----------------\n')
                fprintf('%15s: %s\n','Session name',sessionname)
                fprintf('%15s: %s\n','Export date',savedate)
                fprintf('%15s: %s\n','Patient name',patientname)
                fprintf('%15s: %s\n','Date of birth',dateofbirth)
                fprintf('%15s: %s\n','Gender',gender)
                
            end
            
            
            
            %
            %         function obj = setActiveSession(obj,sessionnr)
            %             if sessionnr > numel(obj.sessionData.SureTune2Sessions.Session) || sessionnr <=0
            %                 disp('Session does not exist')
            %                 return
            %             end
            %
            %             obj.ActiveSession = sessionnr;
            %             obj.getSessions
            %         end
            
            %% Datasets
            
%             function listdatasets(obj)
%             % Function may be obselete.
%                 fprintf('\n\nDatasets for %s:\n',obj.getpatientname)
%                 
%                 for i = 1:numel(obj.sessionData.SureTune2Sessions.Session.datasets.Array.Dataset)
%                     if obj.ativeDataset(obj.activeSession) == i
%                         arrow = '-> ';
%                     else
%                         arrow = '   ';
%                     end
%                     
%                     label = obj.sessionData.SureTune2Sessions.Session.datasets.Array.Dataset{i}.label.Attributes.value;
%                     
%                     fprintf('%s%1.0f - %s\n',arrow,i, label);
%                 end
%             end
%             
            
            
            %% Set/Get
            
            %Name
            function setpatientname(obj,val)
                if nargin == 1
                    val = input('Patient name: ','s');
                end
                
                old = obj.sessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value;
                obj.sessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value = val;
                obj.addtolog('Changed patient name from %s to %s',old,val);
                
            end
            
            function val = getpatientname(obj)
                val = obj.sessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value;
            end
            
            %SessionName
            function setsessionname(obj,val)
                if nargin == 1
                    val = input('Session name: ','s');
                end
                
                old = obj.sessionData.SureTune2Sessions.Session.id.Attributes.value;
                obj.sessionData.SureTune2Sessions.Session.id.Attributes.value = val;
                obj.addtolog('Changed session name from %s to %s',old,val);
                
            end
            
            function val = getsessionname(obj)
                val = obj.sessionData.SureTune2Sessions.Session.id.Attributes.value;
            end
            
            
            %PatientID
            function setpatientid(obj,val)
                if nargin == 1
                    val = input('Patient ID: ','s');
                end
                
                old = obj.sessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value;
                obj.sessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value = val;
                obj.addtolog('Changed patient ID from %s to %s',old,val);
                
            end
            
            function val = getpatientid(obj)
                val = obj.sessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value;
            end
            
            
            %DateOfBirth
            function setdateofbirth(obj,val)
                old = obj.sessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value;
                obj.sessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value = val;
                obj.addtolog('Changed date of birth from %s to %s',old,val);
            end
            
            function val = getdateofbirth(obj)
                val = obj.sessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value;
            end
            
            %Gender
            function setgender(obj,val)
                old = obj.sessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value;
                obj.sessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value = val;
                obj.addtolog('Changed gender from %s to %s',old,val);
            end
            
            function val = getgender(obj)
                val = obj.sessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value;
            end
            
            
            
            %Dataset
            
            function setactivedataset(obj,val)
                %Function may be obsolete.
                if nargin==1
                    obj.listdatasets;
                    val = input('Select dataset number: ');
                    if isempty(val)
                        return
                    end
                end
                
                %check input
                
                if val > 0 && val <= numel(obj.sessionData.SureTune2Sessions.Session.datasets.Array.Dataset)
                    old = obj.ActiveDataset(obj.ActiveSession);
                    obj.ActiveDataset(obj.ActiveSession) = val;
                else
                    error('Out of bounds')
                end
                
                
                obj.addtolog('Changed activeDataset from %1.0f to %1.0f',old,val);
            end
            
            function val = getactivedataset(obj)
                val = obj.ActiveDataset;
            end
            
            
            
            %Registerables
            function varargout = listregisterables(obj)
                val = obj.registerables.names;
                
                
                types = cellfun(@class,obj.registerables.list,'UniformOutput',0);
                
                
                if nargout == 0
                    
                    txt = '\n';
                    for i = 1:numel(val)
                        txt = [txt,'\t',num2str(i),') ',val{i},'   (',types{i},')\n']; %#ok<AGROW>
                    end
                    disp(['All registerables: ',sprintf(txt)])
                    
                    
                    
                elseif nargout ==1
                    varargout{1} = val;
                elseif nargout ==2
                    varargout{1} = val;
                    varargout{2} = types;
                    
                    
                end
                
            end
            
            function varargout = gettransformroot(obj,name)
                if not(checkinputarguments(obj,nargin,1,'Registerable'));return;end
                
                
                if not(ischar(name))
                    name = name.matlabId;
                end
                
                
                
                
                %Find name in list
                index = find(ismember(obj.registerables.names,name));
                if isempty(index) %does not exist
                    error(['Registerable ''',name,''' could not be found.'])
                else
                    
                    namecell = {};
                    Tcell = {};
                    
                    T = eye(4);
                    T = T*obj.registerables.list{index}.transform;
                    
                    %in case nargout = 2, export all steps.
                    Tcell{1} =  T;
                    namecell{1} = name;
                    
                    
                    O = obj.registerables.list{index}.parent;
                    
                    
                    while any(find(ismember(superclasses(O),'Registerable')))
                        T = T*O.transform;
                        
                        %in case nargout = 2, export all steps.
                        Tcell{end+1} = O.transform; %#ok<AGROW>
                        namecell{end+1} = O.matlabId; %#ok<AGROW>
                        
                        O = O.parent;
                    end
                    
                    
                    
                    if nargout==2
                        varargout{1} = Tcell;
                        varargout{2} = namecell;
                    else
                        varargout{1} = T;
                    end
                    
                    
                    
                end
                
                
            end
            
            
            function varargout = gettransformfromto(obj,from,to)
                
                if not(checkinputarguments(obj,nargin,2,'Registerable'));return;end
                
                
                
                %check name 1
                
                if ischar(from)
                    index = find(ismember(obj.registerables.names,from), 1);
                    if isempty(index) %does not exist
                        error(['Registerable ''',from,''' does not exist'])
                    end
                else
                    from = from.matlabId;
                end
                
                %check name 2
                if ischar(to)
                    index = find(ismember(obj.registerables.names,to), 1);
                    if isempty(index) %does not exist
                        error(['Registerable ''',to,''' does not exist'])
                    end
                else
                    to = to.matlabId;
                end
                
                
                
                
                
                if nargout==2
                    
                    [Tfrom,NameFrom] = obj.gettransformroot(from);
                    [Tto,NameTo] = obj.gettransformroot(to);
                    
                    Tto = cellfun(@inv,Tto,'uni',0);
                    
                    varargout{1} = [Tfrom,flip(Tto)];
                    varargout{2} = [NameFrom,flip(NameTo)];
                else
                    Tfrom = obj.gettransformroot(from);
                    Tto = obj.gettransformroot(to);
                    varargout{1} = Tfrom/Tto;  %similar--> Tfrom*inv(Tto)
                end
                
                
                
                
                
            end
            
            function val = getregisterable(obj,name)
                %There are three scenarios:
                % 1. the user gives a name for a registerable
                % 2. the user enters a number
                % 3. the user does not enter anything at all.
                
                if nargin==1
                    %let the user know the options
                    names = obj.listregisterables;
                    txt = '\n';
                    for i = 1:numel(names)
                        txt = [txt,'\t',num2str(i),') ',names{i},'\n']; %#ok<AGROW>
                    end
                    
                    disp(['Choose registerable index number: ',sprintf(txt)])
                    
                    name = input('index number: ');
                end
                
                
                
                
                
                
                switch class(name)
                    case 'char'
                        ii = find(ismember(obj.registerables.names,name));
                    case 'double'
                        ii = name;
                        name = '';
                    case 'array'
                        ii = name;
                        name = 'array';
                    case 'logical'
                        ii = name;
                        name = 'logicals';
                end
                
                
                
                
                
                if isempty(ii) %does not exist
                    error(['Registerable ''',name,''' does not exist'])
                end
                
                val = vertcat(obj.registerables.list{ii});
                
            end
            
            
            %leads
            
            function listleads(obj)
                txt = '\n';
                registerableTypes = cellfun(@class,obj.registerables.list,'UniformOutput',0);
                for iRegisterable = 1:numel(registerableTypes)
                    
                    if strcmp(registerableTypes{iRegisterable},'Lead')
                        thisLead = obj.registerables.list{iRegisterable};
                        
                        txt = [txt,'\t',num2str(iRegisterable),') "',thisLead.matlabId,'"\n',...
                            '\t   Type: ',thisLead.leadType,'\n',...
                            '\t   Stimplans: ',num2str(numel(thisLead.stimPlan)),'\n\n'];
                            
                    end
                
                    
                    
                    
%                                     types = cellfun(@class,obj.registerables.list,'UniformOutput',0);
%                 
%                 
%                 if nargout == 0
%                     
%                     txt = '\n';
%                     for i = 1:numel(val)
%                         txt = [txt,'\t',num2str(i),') ',val{i},'   (',types{i},')\n']; %#ok<AGROW>
%                     end
%                     disp(['All registerables: ',sprintf(txt)])
%                     
%                     
%                     
%                 elseif nargout ==1
%                     varargout{1} = val;
%                 elseif nargout ==2
%                     varargout{1} = val;
%                     varargout{2} = types;
%                     
%                     
%                 end
%                     
                    
                end
                fprintf(txt)
            end
            
            
            
            
            
            %Add New elements
            
            function R = addnewmesh(varargin)
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
                
                
                %replace parent char with its object
                namelist = obj.registerables.names;
                parentindex = find(ismember(namelist,parent));
                
                if isempty(parentindex)
                    warning('Parent is not known. Mesh is added without correct reference')
                else
                    parent = obj.registerables.list{parentindex};
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
            
            
            
            
            function R = addnewdataset(varargin)
                if nargin==1
                    disp('input arguments should be: [object], label,volumeId,Id,Stf,parent,T')
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
                genericPath = 'obj.sessionData.SureTune2Sessions.Session.datasets.Array.Dataset';
                try
                    index = numel(eval(genericPath)) +1;
                catch
                    index =1;
                end
                path = [genericPath,'{',num2str(index),'}'];
                
                
                %replace parent char with its object
                namelist = obj.registerables.names;
                parentindex = find(ismember(namelist,parent));
                
                if isempty(parentindex)
                    warning('Parent is not known. Mesh is added without correct reference')
                else
                    parent = obj.registerables.list{parentindex};
                end
                
                
                component_args = {path,obj};
                registerable_args = {parent,T,1,label}; %set accepted to true
                
                
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
                
                
                %Add to registerable list
                obj.registerables.names{end+1} = label;
                obj.registerables.list{end+1} = R;
                
                
                
                
                
                
                
                
            end
            
            function ObjInstance = makeobj(Session,V,F,name)
                if nargin==1
                    disp('Input Arguments are needed: V,F,name')
                    return
                end
                ObjInstance = Obj(V,F,name);
                ObjInstance.linkToSession(Session);
                
                Session.Meshes.names{end+1}=name;
                Session.Meshes.list{end+1} = ObjInstance;
                
            end
            
            function listvolumes(obj)
                
                for i = 1:numel(obj.volumeStorage.names)
                    fprintf(' %s) %s\n\tSize: %s\n\t%s\n\t%s\n',num2str(i),...
                        obj.volumeStorage.names{i},...
                        mat2str(obj.volumeStorage.list{i}.volumeInfo.dimensions),...
                        obj.volumeStorage.list{i}.volumeInfo.modality,...
                        obj.volumeStorage.list{i}.volumeInfo.scanDirection)
                end
            end
            
            function val=getvolume(obj,index)
                
                %There are three scenarios:
                % 1. the user gives a name for a registerable
                % 2. the user enters a number
                % 3. the user does not enter anything at all.
                
                if nargin==1  %if the user gives not an index. show the options
                    obj.listvolumes
                    string = input('Choose volume index number: ','s');
                    index = str2double(string);
                    
                end
                
                
                switch class(index)
                    case 'char'
                        error('provide an index instead of a volume name')
                        
                end
                
                
                if isempty(index) %does not exist
                    val = [];
                    return
                end
                
                val = vertcat(obj.volumeStorage.list{index});
                
            end
            
            
            
            
            
            
            
            
            
            
            
            
            
        end
        
    end
    

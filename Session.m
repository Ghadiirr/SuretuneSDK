classdef Session < handle
    %SESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Hidden = true)  %These properties are hidden to not bother the user.
        OriginalSessionData
        Directory
        Log
        ActiveSession = 1;
        ActiveDataset = 1;
        Registerables
        Master
        NoLog = 0;
        SureTune = 'C:\Suresuit\Blue3\' %'C:\GIT\SureSuite\Output'
        ExportFolder = 'C:\MATLAB-Addons\Export\';
        
    end
    
    properties
        SessionData
        Volumes
        Meshes
        TherapyPlans
    end
    
    
    
    
    methods(Hidden = true)  %These methods are hidden because they are called from within.
        
        %Logging
        function log(obj,varargin)
            if obj.NoLog;return;end;
            obj.Log{end+1,1} = datestr(datetime);
            fprintf(['\n',sprintf(varargin{:}),'\n']);
            obj.Log{end,2} = sprintf(varargin{:});
        end
        
        %Check if the number of input arguments is correct
        function ok = checkInputArguments(obj,nargin,N,type)
            switch type
                case 'Registerable'
                    if nargin ~= N+1 %+1 = objectt
                        warningtxt = ['Specifiy ',num2str(N),sprintf(' Registerable(s): \n\t  - '),strjoin(obj.getRegs,'\n\t  - ')];
                        ok = 0;
                        error(warningtxt)
                    else ok = 1;
                    end
            end
        end
        
        
    end
    
    methods
        
        
        function obj = Session(varargin)
            if nargin > 0
                warning('No input arguments are required. Run LoadXML to populate session objects.')
            end
            
            %Add empty cells
            
            obj.Volumes.list = {};
            obj.Volumes.names = {};
            obj.TherapyPlans.list = {};
            obj.TherapyPlans.names = {};
            obj.Meshes.list = {};
            obj.Meshes.names = {};
            
            %Make export dir of not already exist
            if ~exist(obj.ExportFolder,'dir')
                mkdir(obj.ExportFolder);
            end
        end
        
        function LoadXML(obj,pathName,fileName)
            
            if nargin == 1
                %read XML file
                [fileName,pathName] = uigetfile('.xml');
                if not(fileName)
                    disp('Aborted by user')
                    return
                end
                xml = SDK_xml2struct([pathName,fileName]);
            elseif nargin==3
                xml = SDK_xml2struct([pathName,fileName]);
            else
                error('Invalid Input')
            end
            
            
            
            % Check for any comments (they may obstruct XML parsing
            if SDK_removeComments(pathName,fileName);
                %repeat reading with new file
                fileName = [fileName(1:end-4),'_nocomments',fileName(end-3:end)];
                
                xml = SDK_xml2struct([pathName,fileName]);
                disp('removed comments')
            end
            
            % Check if there is only one Session. Otherwise throw warning.
            [xml,abort] = SDK_MultipleSessionCheck(xml, pathName,fileName);
            if abort
                return
            end
            
            
            %add properties to object
            obj.OriginalSessionData = xml;
            obj.SessionData = xml;
            obj.Log = {datestr(datetime),['Load file:',pathName,fileName]};
            obj.Directory = pathName;
            
            %print session Info
            obj.getSessionInfo;
            
            %set flag
            obj.ActiveDataset = 1;
            
            obj.NoLog = 1;
            obj.Registerables = SDK_findRegistrables(obj);
            obj.NoLog = 0;
            %             O.Master = O.SessionData.
        end
        
        
        
        
        function LoadZIP(obj,file)
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
            obj.Volumes = obj.loadVolumes([file(1:end-4),'\Volumes']);
            
            %Load Meshes
            obj.Meshes = obj.loadMeshes([file(1:end-4),'\Meshes']);
            
            %Load XML
            obj.LoadXML([file(1:end-4),'\'],'SureTune2Sessions.xml')
            
            %Load Stimplans
            obj.TherapyPlans = obj.loadTherapyPlans([file(1:end-4)]);
            
            
            
        end
        
        
        
        function plans = loadTherapyPlans(obj,sessiondir)
            thisdir = pwd;
            plans = {};
            cd(sessiondir)
            cd('Sessions')
            
            %get into session folder
            try
                cd(obj.getSessionName);
            catch
                disp('No TherapyPlans for this sesson')
                plans = [];
                return
            end
            try
            cd('Leads');
            catch
                disp('No StimPlans')
                return
            end
            LeadNames = SDK_getSubFolders('');
            
            %For all leads find the therapy plans
            for LN = 1:numel(LeadNames)
                thisLead = LeadNames{LN};
                %find thislead in the sessiondata
                [names,types] = obj.getRegs;
                Leadnames = names(ismember(types,'Lead'));
                
                %Find Lead Object
                LeadObject = obj.getReg(Leadnames{~cellfun(@isempty,strfind(Leadnames,thisLead))});
                
                
                TherapyPlans = SDK_getSubFolders(thisLead);
                
                %For all therapy plans make a Therapy Object.
                for TP = 1:numel(TherapyPlans)
                    thisPlan = TherapyPlans{TP};
                    
                    %Find the corresponding SessionData, using the lead
                    %name and therapyplanname
                    
                    obj = LeadObject.session;
                    xmlpath = LeadObject.path;
                    therapyxml = eval(xmlpath);
                    
                    %there may be multiple stimplans in the session data,
                    %find the correct one.
                    index = 0;
                    for ii = 1:numel(therapyxml.stimPlans.Array.StimPlan)
                        if strcmp(therapyxml.stimPlans.Array.StimPlan{ii}.label.Attributes.value,thisPlan)
                            index = ii;
                        end
                    end
                    if index==0;warning(['No matching stimplan in SessionData for ',thisPlan]);return;end
                    
                    
                    
                    
                    
                    
                    %Construct a therapy object using volume and session
                    %data.,
                    
                    volumelist = loadVolumes(obj,[thisLead,'\',thisPlan]);
                    VTA = volumelist;
                    label = thisPlan;
                    voltageBasedStimulation = therapyxml.stimPlans.Array.StimPlan{ii}.voltageBasedStimulation.Attributes.value;
                    stimulationValue = str2double(therapyxml.stimPlans.Array.StimPlan{ii}.stimulationValue.Attributes.value);
                    pulseWidth = str2double(therapyxml.stimPlans.Array.StimPlan{ii}.pulseWidth.Attributes.value);
                    pulseFrequency =str2double(therapyxml.stimPlans.Array.StimPlan{ii}.pulseFrequency.Attributes.value);
                    activeRings = therapyxml.stimPlans.Array.StimPlan{ii}.activeRings.BoolArray.Text;
                    contactsGrounded = therapyxml.stimPlans.Array.StimPlan{ii}.contactsGrounded.BoolArray.Text;
                    annotation = therapyxml.stimPlans.Array.StimPlan{ii}.annotation.Attributes.value;
                    
                    
                    StimplanObject = StimPlan(VTA,LeadObject,label,voltageBasedStimulation,stimulationValue,pulseWidth,pulseFrequency,activeRings,contactsGrounded,annotation);
                    
                    %Add the therapy object to Lead.StimPlan{end+1}
                    
                    LeadObject.stimplan{end+1} = StimplanObject;
                    plans{end+1} = StimplanObject;
                    
                    
                    
                    
                end
                
                
                
                
                
                
            end
            
            
            
            cd(thisdir)
        end
        
        
        
        function meshlist = loadMeshes(thisSession,folder)
            thisdir = pwd;
            cd(folder)
            
            %get a list with all obj files
            meshlist.list = {};
            meshlist.names = {};
            objfiles = dir('*.obj');
            objnames ={objfiles.name};
            
            
            for i = 1:numel(objnames)
                if ~iscell(objnames)
                    filename = objnames;
                else
                    
                    filename = objnames{i};
                end
                
                %Read the OBJ file
                [V,F] = read_vertices_and_faces_from_obj_file(filename);
                
                
                %Add an Obj instance to the list.
                meshlist.list{i} = Obj(V,F,filename);
                meshlist.list{i}.LinkToSession(thisSession)
                
                %Add the name to the list.
                meshlist.names{i} = filename;
                
                if ~iscell(objnames)
                    break
                    
                end
                
            end
            
            cd(thisdir)
            
        end
        
        function volumelist = loadVolumes(thisSession,folder)
            thisdir = pwd;
            cd(folder)
            
            %get a list with all obj files
            volumelist.list = {};
            volumelist.names = {};
            
            d = dir();
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds(ismember(nameFolds,{'.','..'})) = [];
            
            for i = 1:numel(nameFolds)
                %Add an Volume instance to the list.
                V = Volume;
                V.loadVolume(nameFolds{i});
                
                V.LinkToSession(thisSession);
                
                volumelist.list{i} = V;
                volumelist.names{i} = nameFolds{i};
                
                
            end
            cd(thisdir)
            
        end
        
        function import2SureTune(obj)
            disp('Saving Files...')
            %             importfilename =
            thisdir = pwd;
            cd(obj.Directory)
            
            
            %Save Sessions
            SDK_Session2XML(obj.SessionData,'SureTune2Sessions.xml')
            SDK_Session2XML(obj.OriginalSessionData,'OriginalSession.xml')
            
            %Save Meshes
            for m = 1:numel(obj.Meshes.list);
                obj.Meshes.list{m}.saveToFolder('Meshes')
                
                %also save the mesh to meshstorage:
                vertface2obj( obj.Meshes.list{m}.V, obj.Meshes.list{m}.F,[obj.SureTune,'MeshStorage/',obj.Meshes.list{m}.FileName])
            end
            
            %Save new Volumes
            for v = 1:numel(obj.Volumes.list);
                
                obj.Volumes.list{v}.saveToFolder(['Volumes/',obj.Volumes.names{v}]);
            end
            
            %export log
            T = cell2table(obj.Log,'VariableNames',{'datetime','action'});
            writetable(T,[obj.Directory,'/Log.txt'],'Delimiter','\t')
            
            % zip
            disp('Zipping Session...')
            eval('!C:/MATLAB-Addons/SDK/7za.exe a -tzip -r -bd -- session.zip '); %-xr@Log.txt -xr@OriginalSession.xml
            
            
            %Import
            disp('Importing Session')
            cd(obj.SureTune)
            
            fclose all;
            
            eval(['!SureplanArchive.exe /noencryption /importsessions ',obj.Directory,'session.zip'])
            
            cd(thisdir)
            
        end
        
        
        function getSessionFromSureTune(obj, wildcard)
            
            if nargin<2
                disp('input arguments: wildcard')
                disp('wildcard: ''*01*'' to filter on filenames that contain 01')
            end
            thisdir = pwd;
            
            filename = 'MATLABinput.zip';
            

            cd(obj.SureTune)
            try delete(filename);catch;end
            [~,~] = rmdir('MATLABinput','s') ;
            
            eval(['!SureplanArchive.exe /noencryption /patientname "',wildcard,'" /exportsessions ',filename])
            obj.LoadZIP([obj.SureTune,filename])
            
            cd(thisdir)
        end
        
        
        
        
        function saveSessionAs(obj)
            %             importfilename =
            [folder] = uigetdir(pwd,'Select directory to save Session');
            thisdir = pwd;
            
            SDK_Session2XML(obj.SessionData,[folder,'/Session.xml'])
            SDK_Session2XML(obj.OriginalSessionData,[folder,'/OriginalSession.xml'])
            
            %export log
            T = cell2table(obj.Log,'VariableNames',{'datetime','action'});
            writetable(T,[folder,'/Log.txt'],'Delimiter','\t')
            
            
        end
        
        
        %% Logging
        
        
        function getLog(obj)
            transposed = transpose(obj.Log);
            fprintf('%s\t%s\n',transposed{:})
            
        end
        
        
        
        %% Sessions
        
        function getSessionInfo(obj)
            sessionname = obj.SessionData.SureTune2Sessions.Session.id.Attributes.value;
            patientname = obj.SessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value;
            dateofbirth = obj.SessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value;
            gender = obj.SessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value;
            patientid = obj.SessionData.SureTune2Sessions.Session.patient.Patient.patientID;
            savedate = obj.SessionData.SureTune2Sessions.Attributes.exportDate;
            
            fprintf('Session info\n-----------------\n')
            fprintf('%15s: %s\n','Session name',sessionname)
            fprintf('%15s: %s\n','Export date',savedate)
            fprintf('%15s: %s\n','Patient name',patientname)
            fprintf('%15s: %s\n','Date of birth',dateofbirth)
            fprintf('%15s: %s\n','Gender',gender)
            
            %              fprintf('%s\n\t   %s\n\t   %s\n\t   %s\n\t   %s\n','     ', sessionname, patientname, dateofbirth, gender);
            
            
            %session ID
            %Save date
            
            %PatientName
            %Gender
            %Date of Birth
            
        end
        
        
        
        %
        %         function obj = setActiveSession(obj,sessionnr)
        %             if sessionnr > numel(obj.SessionData.SureTune2Sessions.Session) || sessionnr <=0
        %                 disp('Session does not exist')
        %                 return
        %             end
        %
        %             obj.ActiveSession = sessionnr;
        %             obj.getSessions
        %         end
        
        %% Datasets
        
        function getDatasets(obj)
            
            fprintf('\n\nDatasets for %s:\n',obj.getPatientName)
            
            for i = 1:numel(obj.SessionData.SureTune2Sessions.Session.datasets.Array.Dataset)
                if obj.ActiveDataset(obj.ActiveSession) == i
                    arrow = '-> ';
                else
                    arrow = '   ';
                end
                
                label = obj.SessionData.SureTune2Sessions.Session.datasets.Array.Dataset{i}.label.Attributes.value;
                
                fprintf('%s%1.0f - %s\n',arrow,i, label);
            end
        end
        
        
        
        %% Set/Get
        
        %Name
        function setPatientName(obj,val)
            if nargin == 1
                val = input('Patient name: ','s');
            end
            
            old = obj.SessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value;
            obj.SessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value = val;
            obj.log('Changed patient name from %s to %s',old,val);
            
        end
        
        function val = getPatientName(obj)
            val = obj.SessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value;
        end
        
        %SessionName
        function setSessionName(obj,val)
            if nargin == 1
                val = input('Session name: ','s');
            end
            
            old = obj.SessionData.SureTune2Sessions.Session.id.Attributes.value;
            obj.SessionData.SureTune2Sessions.Session.id.Attributes.value = val;
            obj.log('Changed session name from %s to %s',old,val);
            
        end
        
        function val = getSessionName(obj)
            val = obj.SessionData.SureTune2Sessions.Session.id.Attributes.value;
        end
        
        
        %PatientID
        function setPatientID(obj,val)
            if nargin == 1
                val = input('Patient ID: ','s');
            end
            
            old = obj.SessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value;
            obj.SessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value = val;
            obj.log('Changed patient ID from %s to %s',old,val);
            
        end
        
        function val = getPatientID(obj)
            val = obj.SessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value;
        end
        
        
        %DateOfBirth
        function setDateOfBirth(obj,val)
            old = obj.SessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value;
            obj.SessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value = val;
            obj.log('Changed date of birth from %s to %s',old,val);
        end
        
        function val = getDateOfBirth(obj)
            val = obj.SessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value;
        end
        
        %Gender
        function setGender(obj,val)
            old = obj.SessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value;
            obj.SessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value = val;
            obj.log('Changed gender from %s to %s',old,val);
        end
        
        function val = getGender(obj)
            val = obj.SessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value;
        end
        
        
        
        %Dataset
        
        function setActiveDataset(obj,val)
            
            if nargin==1
                obj.getDatasets;
                val = input('Select dataset number: ');
                if isempty(val)
                    return
                end
            end
            
            %check input
            
            if val > 0 && val <= numel(obj.SessionData.SureTune2Sessions.Session.datasets.Array.Dataset)
                old = obj.ActiveDataset(obj.ActiveSession);
                obj.ActiveDataset(obj.ActiveSession) = val;
            else
                error('Out of bounds')
                return
            end
            
            
            obj.log('Changed activeDataset from %1.0f to %1.0f',old,val);
        end
        
        function val = getActiveDataset(obj)
            val = obj.ActiveDataset;
        end
        
        
        
        %Registerables
        function varargout = getRegs(obj)
            val = obj.Registerables.names;
            
            
            types = cellfun(@class,obj.Registerables.list,'UniformOutput',0);
            
            
            if nargout == 0
                
                txt = ['\n'];
                for i = 1:numel(val)
                    txt = [txt,'\t',num2str(i),') ',val{i},'   (',types{i},')\n'];
                end
                disp(['All registerables: ',sprintf(txt)])
                
                
                
            elseif nargout ==1
                varargout{1} = val;
            elseif nargout ==2
                varargout{1} = val;
                varargout{2} = types;
                
                
            end
            
        end
        
        function varargout = getTRoot(obj,name)
            if not(checkInputArguments(obj,nargin,1,'Registerable'));return;end
            
            
            if not(ischar(name))
                name = name.MATLABid;
            end
            
            
            
            
            %Find name in list
            index = find(ismember(obj.Registerables.names,name));
            if isempty(index) %does not exist
                varargout = [];
                error(['Registerable ''',name,''' could not be found.'])
                return
            else
                
                namecell = {};
                Tcell = {};
                
                T = eye(4);
                T = T*obj.Registerables.list{index}.T;
                
                %in case nargout = 2, export all steps.
                Tcell{1} =  T;
                namecell{1} = name;
                
                
                O = obj.Registerables.list{index}.parent;
                
                
                while any(find(ismember(superclasses(O),'Registerable')))
                    T = T*O.T;
                    
                    %in case nargout = 2, export all steps.
                    Tcell{end+1} = O.T;
                    namecell{end+1} = O.MATLABid;
                    
                    O = O.parent;
                end
                
                
                
                if nargout==2
                    varargout{1} = Tcell;
                    varargout{2} = namecell;
                else
                    varargout{1} = T;
                end
                
                
                val = T;
            end
            
            
        end
        
        
        function varargout = getTfromto(obj,from,to)
            
            if not(checkInputArguments(obj,nargin,2,'Registerable'));return;end
            
            
            
            %check name 1
            
            if ischar(from)
                index = find(ismember(obj.Registerables.names,from));
                if isempty(index) %does not exist
                    varargout = [];
                    error(['Registerable ''',from,''' does not exist'])
                    return
                end
            else
                from = from.MATLABid;
            end
            
            %check name 2
            if ischar(to)
                index = find(ismember(obj.Registerables.names,to));
                if isempty(index) %does not exist
                    varargout = [];
                    error(['Registerable ''',to,''' does not exist'])
                    return
                end
            else
                to = to.MATLABid;
            end
            
            
            
            
            
            if nargout==2
                
                [Tfrom,NameFrom] = obj.getTRoot(from);
                [Tto,NameTo] = obj.getTRoot(to);
                
                Tto = cellfun(@inv,Tto,'uni',0);
                
                varargout{1} = [Tfrom,flip(Tto)];
                varargout{2} = [NameFrom,flip(NameTo)];
            else
                Tfrom = obj.getTRoot(from);
                Tto = obj.getTRoot(to);
                varargout{1} = Tfrom/Tto;  %similar--> Tfrom*inv(Tto)
            end
            
            
            
            
            
        end
        
        function val = getReg(obj,name)
            %There are three scenarios:
            % 1. the user gives a name for a registerable
            % 2. the user enters a number
            % 3. the user does not enter anything at all.
            
            if nargin==1
                %let the user know the options
                names = obj.getRegs;
                txt = ['\n'];
                for i = 1:numel(names)
                    txt = [txt,'\t',num2str(i),') ',names{i},'\n'];
                end
                
                disp(['Choose registerable index number: ',sprintf(txt)])
                
                name = input('index number: ');
            end
            
            
            
            
            
            
            switch class(name)
                case 'char'
                    ii = find(ismember(obj.Registerables.names,name));
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
                varargout = [];
                error(['Registerable ''',name,''' does not exist'])
                return
            end
            
            val = vertcat(obj.Registerables.list{ii});
            
        end
        
        
        %leads
        
        function val = getLeads(obj)
            nleads = numel(obj.SessionData.SureTune2Sessions.Session.leads.Array.Lead);
            for n = 1:nleads
                
                %think of something clever.
                
                
            end
        end
        
        
        
        
        
        %Add New elements
        
        function R = addNewMesh(varargin)
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
            genericPath = 'obj.SessionData.SureTune2Sessions.Session.importedMeshes.Array.ImportedStructure';
            try
                index = numel(eval(genericPath)) +1;
            catch
                index =1;
            end
            path = [genericPath,'{',num2str(index),'}'];
            
            
            %replace parent char with its object
            namelist = obj.Registerables.names;
            parentindex = find(ismember(namelist,parent));
            
            if isempty(parentindex)
                warning('Parent is not known. Mesh is added without correct reference')
            else
                parent = obj.Registerables.list{parentindex};
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
            A.Attributes.id = label;
            
            %add dummy elements
            eval([path,' = A'])
            
            R = ImportedStructure(component_args, registerable_args,label,opacity);
            
            obj.Registerables.names{end+1} = label;
            obj.Registerables.list{end+1} = R;
            
            
            
            
            
        end
        
        
        
        
        function R = addNewDataset(varargin)
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
            genericPath = 'obj.SessionData.SureTune2Sessions.Session.datasets.Array.Dataset';
            try
                index = numel(eval(genericPath)) +1;
            catch
                index =1;
            end
            path = [genericPath,'{',num2str(index),'}'];
            
            
            %replace parent char with its object
            namelist = obj.Registerables.names;
            parentindex = find(ismember(namelist,parent));
            
            if isempty(parentindex)
                warning('Parent is not known. Mesh is added without correct reference')
            else
                parent = obj.Registerables.list{parentindex};
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
       
           
            A.Attributes.id = label;
            
            %add dummy elements
            eval([path,' = A'])
            
            
            %Add volume to volume list
            obj.Volumes.names{end+1} = label;
            obj.Volumes.list{end+1} = vObject;
            
            R = Dataset(component_args, registerable_args,label,volumeId,Id,stf);
            
            
            %Add to registerable list
            obj.Registerables.names{end+1} = label;
            obj.Registerables.list{end+1} = R;
            

            
            
            
            
            
            
        end
        
        function makeObj(Session,V,F,name)
            
            ObjInstance = Obj(V,F,name);
            ObjInstance.LinkToSession(Session);
            
            Session.Meshes.names{end+1}=name;
            Session.Meshes.list{end+1} = ObjInstance;
            
        end
        
        function listVolumes(obj)
            
            for i = 1:numel(obj.Volumes.names)
                fprintf(' %s) %s\n\tSize: %s\n\t%s\n\t%s\n',num2str(i),...
                    obj.Volumes.names{i},...
                    mat2str(obj.Volumes.list{i}.VolumeInfo.Dimensions),...
                    obj.Volumes.list{i}.VolumeInfo.Modality,...
                    obj.Volumes.list{i}.VolumeInfo.ScanDirection)
            end
        end
        
       function val=getVolume(obj,index)
            
 %There are three scenarios:
            % 1. the user gives a name for a registerable
            % 2. the user enters a number
            % 3. the user does not enter anything at all.
            
            if nargin==1  %if the user gives not an index. show the options
                obj.listVolumes
                string = input('Choose volume index number: ','s');
                index = str2num(string);
                
            end
            

            switch class(index)
                case 'char'
                    error('provide an index instead of a volume name')
                    obj.listVolumes;
            end
            

            if isempty(index) %does not exist
                val = [];
                return
            end
            
            val = vertcat(obj.Volumes.list{index});
            
        end
            
        
        
        
        
        
        
        
        
        
        
        
        
    end
    
end


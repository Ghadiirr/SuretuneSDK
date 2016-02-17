classdef Patient < SessionComponent
    %PATIENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        patientID
        dateOfBirth
        gender
    end
    
    properties (Hidden = true)
        matlabId = 'Patient';
    end
    
    methods
        function obj = Patient(path,session)%,name,patientID,dateOfBirth,gender)
            
            obj@SessionComponent(path,session);
            obj.name = trytoget('session.sessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value');
            obj.patientID = trytoget('session.sessionData.SureTune2Sessions.Session.patient.Patient.patientID.Attributes.value');
            obj.dateOfBirth = trytoget('session.sessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value');
            obj.gender = trytoget('session.sessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value');
            
            function output = trytoget(path)
                try
                    output = eval(path);
                catch
                    output = 'empty';
                end
            end
            
        end
        
        function obj = set.name(obj,name)
            S = obj.session;
            if ~S.updateXml;obj.name = name; return;end
            
            if SDK_readabledialog(obj.session)
                %change the value in the object
                obj.name = name;
                
                %update the XML
                SDK_updatexml(S,obj,'.name.Attributes.value',name,'patient name');
            end
            
        end
        
        
        function obj = set.patientID(obj,patientID)
            S = obj.session;
            if ~S.updateXml;obj.patientID = patientID; return;end
            
            if SDK_readabledialog(obj.session)
                %change the value in the object
                obj.patientID = patientID;
                
                
                %update the XML
                SDK_updatexml(S,obj,'.patientID.Attributes.value',patientID,'patient ID');
            end
        end
        
        
        function obj = set.dateOfBirth(obj,dateOfBirth)
            S = obj.session;
            if ~S.updateXml;obj.dateOfBirth = dateOfBirth; return;end
            
            %change the value in the object
            obj.dateOfBirth = dateOfBirth;
            
            if ischar(dateOfBirth)
                if strcmp(dateOfBirth,'empty')
                    structure.Null.Text = [];
                    SDK_updatexml(S,obj,'.dateOfBirth',structure,'date of birth');
                end
            end
            
            
            
            %update the XML
            SDK_updatexml(S,obj,'.dateOfBirth.Attributes.value',dateOfBirth,'date of birth');
        end
        
        
        function obj = set.gender(obj,gender)
            S = obj.session;
            if ~S.updateXml;obj.gender = gender; return;end
            
            %change the value in the object
            obj.gender = gender;
            
            %update the XML
            SDK_updatexml(S,obj,'.gender.Enum.Attributes.value',gender,'gender');
        end
        
        
        
        
    end
    
end


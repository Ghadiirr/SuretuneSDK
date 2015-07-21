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
        function obj = Patient(path,session,name,patientID,dateOfBirth,gender)
            
            obj@SessionComponent(path,session);
            obj.name = name;
            obj.patientID = patientID;
            obj.dateOfBirth = dateOfBirth;
            obj.gender = gender;
            
            
        end
        
        function obj = set.name(obj,name)
            S = obj.session;
            if ~S.updateXml;obj.name = name; return;end
            
            %change the value in the object
            obj.name = name;
            
            %update the XML
            SDK_updatexml(S,obj,'.name.Attributes.value',name,'patient name');
            
            
        end
        
        
        function obj = set.patientID(obj,patientID)
            S = obj.session;
            if ~S.updateXml;obj.patientID = patientID; return;end
            
            %change the value in the object
            obj.patientID = patientID;
            
            %update the XML
            SDK_updatexml(S,obj,'.patientID.Attributes.value',patientID,'patient ID');
        end
        
        
        function obj = set.dateOfBirth(obj,dateOfBirth)
            S = obj.session;
            if ~S.updateXml;obj.dateOfBirth = dateOfBirth; return;end
            
            %change the value in the object
            obj.dateOfBirth = dateOfBirth;
            
            %update the XML
            SDK_updatexml(S,obj,'..dateOfBirth.Attributes.value',dateOfBirth,'date of birth');
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


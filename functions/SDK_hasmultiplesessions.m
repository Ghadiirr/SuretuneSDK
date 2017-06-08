function [ xml, abort ] = SDK_hasmultiplesessions( xml,pathName,fileName )

%This function checks if multiple sessions are saved in the same xml file.
%If this is the case, only the first one will be used. 
%A pop-up window will ask if other sessions should be saved individually


abort = 0;

%get version
ver = fieldnames(xml);
ver = ver{1};


if iscell(xml.(ver).Session)
    
    ids = ['\n'];
    for i = 1:numel(xml.(ver).Session)
        ids = [ids,'\t* ',xml.(ver).Session{i}.id.Attributes.value, '(',xml.(ver).Session{i}.lastSaved.Attributes.value,')\n'];
        
    end
    text = ['The Sessionfile contains multiple sessions:',sprintf(ids),sprintf('\n Only the first session will be imported into matlab. Would you like to export all sessions to seperate files?')];
    
    
    
    % Construct a questdlg with three options
    choice = questdlg(text,'Muliple Sessions have been found....','Yes','No','Cancel','Cancel');
    % Handle response
    switch choice
        case 'Yes'
            %If user wants to save all files sperately
            
            thisDir = pwd;
            cd(pathName)
            for i = 1:numel(xml.(ver).Session)
                newXML = xml;
                newXML.(ver).Session = newXML.(ver).Session{i};
                struct2xml(newXML,[fileName(1:end-4),'_Session_',num2str(i),'.xml'])
            end
            cd(thisDir)

            xml.(ver).Session = xml.(ver).Session{1};

        case 'No'
             xml.(ver).Session = xml.(ver).Session{1};

        case 'Cancel'

            abort = 1;
     end
    
    
    



end
end
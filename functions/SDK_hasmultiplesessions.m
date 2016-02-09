function [ xml, abort ] = SDK_hasmultiplesessions( xml,pathName,fileName )

%This function checks if multiple sessions are saved in the same xml file.
%If this is the case, only the first one will be used. 
%A pop-up window will ask if other sessions should be saved individually


abort = 0;
namesStruct = fieldnames(xml);
sureSuiteProduct = namesStruct(strncmpi(namesStruct,'sure',4));
if iscell(xml.(sureSuiteProduct{1}).Session)
    ids = cell(1,numel(xml.(sureSuiteProduct{1}).Session));
    for i = 1:numel(xml.(sureSuiteProduct{1}).Session)
        ids{i} = ['\n\t* ',xml.(sureSuiteProduct{1}).Session{i}.id.Attributes.value, '(',xml.(sureSuiteProduct{1}).Session{i}.lastSaved.Attributes.value,')'];
        
    end
    text = ['The Sessionfile contains multiple sessions:',sprintf([ids{:}]),sprintf('\nOnly the first session will be imported into matlab. Would you like to export all sessions to seperate files?')];
    
    
    
    % Construct a questdlg with three options
    choice = questdlg(text,'Muliple Sessions have been found....','Yes','No','Cancel','Cancel');
    % Handle response
    switch choice
        case 'Yes'
            %If user wants to save all files sperately
            
            thisDir = pwd;
            cd(pathName)
            for i = 1:numel(xml.(sureSuiteProduct{1}).Session)
                newXML.(sureSuiteProduct{1}) = struct('Session',xml.(sureSuiteProduct{1}).Session{i},...
                    'Attributes',xml.(sureSuiteProduct{:}).Attributes);
                SDK_session2xml(newXML,[fileName(1:end-4),'_Session_',num2str(i),'.xml'])
            end
            cd(thisDir)

            xml.(sureSuiteProduct{1}).Session = xml.(sureSuiteProduct{1}).Session{1};

        case 'No'
             xml.(sureSuiteProduct{1}).Session = xml.(sureSuiteProduct{1}).Session{1};

        case 'Cancel'

            abort = 1;
     end
    
    
    



end
end
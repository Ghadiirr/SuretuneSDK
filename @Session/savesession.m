function savesession(obj)
[folder] = uigetdir(pwd,'Select directory to save Session');


SDK_session2xml(obj.sessionData,[folder,'/Session.xml'])
SDK_session2xml(obj.originalSessionData,[folder,'/OriginalSession.xml'])

%export log
table = cell2table(obj.log,'VariableNames',{'datetime','action'});
writetable(table,[folder,'/Log.txt'],'Delimiter','\t')


end

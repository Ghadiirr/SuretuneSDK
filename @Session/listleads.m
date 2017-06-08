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

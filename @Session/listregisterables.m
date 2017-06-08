function varargout = listregisterables(obj)
val = obj.registerables.names;


types = cellfun(@class,obj.registerables.list,'UniformOutput',0);



if nargout == 0
    
    txt = '\n';
    for i = 1:numel(val)
        switch types{i}
            case 'Dataset'
                txt = [txt,'\t',num2str(i),') ',val{i},'     (',types{i},': ',obj.registerables.list{i}.label,')\n']; %#ok<AGROW>
            otherwise
                txt = [txt,'\t',num2str(i),') ',val{i},'   (',types{i},')\n']; %#ok<AGROW>
        end
    end
    disp(['All registerables: ',sprintf(txt)])
    
    
    
elseif nargout ==1
    varargout{1} = val;
elseif nargout ==2
    varargout{1} = val;
    varargout{2} = types;
    
    
end

end
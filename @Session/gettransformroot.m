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
   % T = T*obj.registerables.list{index}.transform;
    try 
T = T*obj.registerables.list{index}.transform;
catch
keyboard
end
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
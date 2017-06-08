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
function val = getregisterable(obj,name)
%There are three scenarios:
% 1. the user gives a name for a registerable
% 2. the user enters a number
% 3. the user does not enter anything at all.

if nargin==1
    %let the user know the options
    %                     names = obj.listregisterables;
    %                     txt = '\n';
    %                     for i = 1:numel(names)
    %                         txt = [txt,'\t',num2str(i),') ',names{i},'\n']; %#ok<AGROW>
    %                     end
    obj.listregisterables;
    
    
    name = input('Choose registerable index number: ');
end




ii = [];

switch class(name)
    case 'char'
        ii = find(ismember(obj.registerables.names,name));
    case 'double'
        ii = name;
        name = '';
    case 'logical'
        ii = name;
        name = 'logicals';
    otherwise
        if any(ismember(superclasses(name),'Registerable'))
            ii = find(ismember(obj.registerables.names,name.matlabId));
            name = 'Registerable';
        end
        
        
end





if isempty(ii) %does not exist
    error(['Registerable ''',name,''' does not exist'])
end

val = vertcat(obj.registerables.list{ii});

end

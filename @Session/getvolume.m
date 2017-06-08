function val=getvolume(obj,index)

%There are three scenarios:
% 1. the user gives a name for a registerable
% 2. the user enters a number
% 3. the user does not enter anything at all.

if nargin==1  %if the user gives not an index. show the options
    obj.listvolumes
    string = input('Choose volume index number: ','s');
    index = str2double(string);
    
end


switch class(index)
    case 'char'
        error('provide an index instead of a volume name')
        
end


if isempty(index) %does not exist
    val = [];
    return
end

val = vertcat(obj.volumeStorage.list{index});

end

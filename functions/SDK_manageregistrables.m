function [ Regs ] = SDK_manageregistrables(obj, Regs, P, level,R )
%SDK_MANAGEREGISTRABLES Summary of this function goes here
%   Detailed explanation goes here

thisChild = P{level};

flag = 0;  %1: accepted  2: parent,  3:transform
switch thisChild
    case 'accepted'
        flag = 1;
    case 'parent'
        flag = 2;
    case 'transfom'
        flag = 3;
end

%Return if no registrable
if flag==0
    return
end


%Return if link is already in Regs
Plevel = {P{1:level-1}};
link= ['obj.',strjoin(Plevel,'.')];  %get current link

allLinks = {Regs{1,:}};
if not(isempty(find(ismember(allLinks,link))));
    return
end


%---  We are dealing with a new registrable--%

fprintf('\b\b\b%03.0f',size(Regs,2)+1)



%accepted
try
    accepted = eval([link,'.accepted.Attributes.value']);
catch
    accepted = [];
end

%parent

try
    if isfield(eval([link,'.parent']),'Null') %if it is master
        parentID = 'ROOT';
    else
        parentID = eval([link,'.parent.ref.Attributes.id']);
    end
catch
    
    parentID = 'None';
    
end



%T
try
    M3D = eval([link,'.transform.Matrix3D']);
    T = SDK_matrix3d2transform(M3D);
catch
    T = 'None';
end







% Type
%Last fieldname without cell index:
withCellIndex = Plevel{end};
withoutCellIndex = withCellIndex(isletter(withCellIndex));
RegisterableType = withoutCellIndex;


%MATLABid
%id
try
    if strcmp(RegisterableType,'Lead')
        if isfield(eval(link),'Attributes')
            id =  eval([link,'.Attributes.id']);  %Lead alredy has Id
            
        else
            id = ['Lead_',eval([link,'.label.Attributes.value'])];
            eval([link,'.Attributes.id = ''',id,''';']);  %Lead does not have Id
        end
    else
        
        id = eval([link,'.Attributes.id']);
        % id = P{level-1};
    end
catch
    try
        id = ['ID_',eval([link,'.label.Attributes.value'])];
    catch
        try id = ['MeshId_',eval([link,'.meshId.Attributes.value'])];
        catch
            id = 'None';
        end
    end
end









%save
ind = size(Regs,2)+1;
Regs{1,ind} = link;
Regs{2,ind} = RegisterableType;
Regs{3,ind} = id;
Regs{4,ind} = accepted;
Regs{5,ind} = parentID;
Regs{6,ind} = T;






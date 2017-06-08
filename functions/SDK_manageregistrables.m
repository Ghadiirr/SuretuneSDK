function [ Regs ] = SDK_manageregistrables(obj, Regs, P, level)
%SDK_MANAGEREGISTRABLES Summary of this function goes here
%   Detailed explanation goes here

thisChild = P{level};
% Only true for registerable
if any(strcmp({'accepted','parent','transfom'},thisChild))
    
    %Return if link is already in Regs
    Plevel = {P{1:level-1}};
    link= ['obj.',strjoin(Plevel,'.')];  %get current link
    
    if ~isempty(Regs)
        allLinks = Regs(1,:);
        if any(ismember(allLinks,link));
            return
        end
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
            if strfind(parentID,'ACPCIH')
                obj.developerFlags.echoLog = 0;
                obj.addtolog('Changed ACPC-id from ',parentID,' to acpcCoordinateSystem!')
                obj.developerFlags.echoLog = 1;
                parentID = 'acpcCoordinateSystem';
            end
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
            %         if isfield(eval(link),'Attributes')
            %             id =  eval([link,'.Attributes.id']);  %Lead alredy has Id
            %
            %         else
            try
                id = eval([link,'.Attributes.id']);
            catch
                id = ['Lead_',eval([link,'.label.Attributes.value'])];
                eval([link,'.Attributes.id = ''',id,''';']);  %Lead does not have Id
            end
            %         end
            
        elseif strcmp(RegisterableType,'ACPCIH')

                id = 'acpcCoordinateSystem';
                
        elseif strcmp(RegisterableType,'MerAnnotation')
                id = ['MerAnnotation_',eval([link,'.merTable.ref.Attributes.id'])];

            
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
end




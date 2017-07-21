function [  ] = fixatlas( S )
%FIXATLAS Summary of this function goes here
%   Detailed explanation goes here

S.updateXml = 0;
[names,types] = S.listregisterables;

originalname = [];
newname = [];
definition = [];
id = [];
ref = {};

index = 0;

if any(contains(types,'Atlas'))
    for iAtlas = find(contains(types,'Atlas'))
        index = index+1;
        thisAtlas = S.getregisterable(iAtlas);
        originalname{index} = thisAtlas.matlabId;
        
        %if the atlas has no blanks
        if ~contains(thisAtlas.group,'AtlasDefinition')
            definition{index} = thisAtlas.group;
            obj = S;
            try %Attribute only exists if it has  a child.
                ref{index} = eval([thisAtlas.path,'.atlasDefinition.AtlasDefinition.Attributes.id']);
            catch
                ref{index} = '';
            end
            newname = ['yeb',lower(thisAtlas.group),lower(thisAtlas.hemisphere)];
        else
            ref{index} = '';
            atlasdefref = find(contains(ref,thisAtlas.group));
            group = definition{atlasdefref};
            thisAtlas.group = group;
            newname = ['yeb',lower(group),lower(thisAtlas.hemisphere)];
        end
        
        %apply newname
        thisAtlas.matlabId = newname;
        S.registerables.names{iAtlas} = newname;
            
            
            
        
    end
    
    
end
S.updateXml = 1;

end


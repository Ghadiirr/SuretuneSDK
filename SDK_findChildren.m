function [ children ] = SDK_findChildren( obj,name )
%SDK_FINDCHILDREN Summary of this function goes here
%   Detailed explanation goes here
    
    %Output:
    children = {};
    
    %instead of a name, a Registerable may be an input argument
    if strcmp(class(name),'Registerable')
        name = name.MATLABName;
    end
    
    
    %get a list of all registerables
    Regs = obj.getRegs;
    
    for i = 1:numel(Regs)
        thisRegName = Regs{i};
        thisReg = obj.getReg(thisRegName);
        if strcmp(class(thisReg.parent),'Registerable')
            if strcmp(thisReg.parent.MATLABName,name)
                children{end+1} = thisRegName;
            end
        end

            
        
    end
    
    
    

end


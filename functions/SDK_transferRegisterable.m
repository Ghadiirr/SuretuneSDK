function [ Rout ] = SDK_transferRegisterable( R,to )
%SDK_TRANSFERREGISTERABLE Summary of this function goes here
%   Detailed explanation goes here

switch class(R)
    case 'ImportedStructure'
        disp('structure')
        SDK_transferImportedSturcture
    case 'Dataset'
        disp('dataset')
        SDK_transferDataset
    otherwise
        error(['This function does not (yet) support registerables of type:',class(R)])
end


%% sub functions

    function SDK_transferImportedSturcture()
        [names,~] = to.listregisterables;
        
        %see if name already exists, then get unique name
        uniquename = R.matlabId;
        while any(ismember(names,uniquename))
            uniquename = [uniquename,'_copy'];
        end
        
        %see if parent exists, otherwise ask userinpu     
        if ~any(ismember(names,R.parent.matlabId))
            disp(['No registerable was found named ',R.parent.matlabId])
            disp('Please select parent from list')
            R.parent = to.getregisterable;
        end
        
        newR = to.addnewmesh(uniquename,R.opacity,R.parent,R.transform);
        
        
        %Transfer parts 
        meshids = to.meshStorage.names;
        
        for iPart = 1:numel(R.parts)
            thispart = R.parts{iPart};
            
            %if id already exists, then get unique name
            uniqueid = thispart.meshId;
            while any(ismember(names,uniqueid))
                uninqueid = [uniqueid(1:end-4),'_copy.obj'];
            end
            
            newObj = Obj(thispart.obj.v,thispart.obj.f,uniqueid);
            newObj.linktosession(to);
            
            newR.addnewpart(uniqueid,thispart.color,thispart.opacity,thispart.transform,uniqueid);
        end
        
        Rout = to.getregisterable(uniquename);
        disp('Imported Structure has been transfered succesfully')
        
    end

    function SDK_transferDataset
        [names,~] = to.listregisterables;
        
        %see if name already exists, then get unique name
        uniquename = R.matlabId;
        while any(ismember(names,uniquename))
            uniquename = [uniquename,'_copy'];
        end
        
        %see if parent exists, otherwise ask userinput     
        if ischar(R.parent)
            if strcmp(R.parent,'ROOT');
                R.parent = to.getregisterable(1);
                R.transform = eye(4);
            end
        end
        if ~any(ismember(names,R.parent.matlabId))
            disp(['No registerable was found named ',R.parent.matlabId])
            disp('Please select parent from list')
            R.parent = to.getregisterable;
        end
        
        
        % Make new Volume        

        V = Volume;
        V.newvolume(R.volume.volumeInfo,R.volume.voxelArray,to)
        
        %Make new Dataset
        to.addnewdataset(uniquename,R.volumeId,R.volumeId,R.stf,R.parent,R.transform,V);
        
        Rout = to.getregisterable(uniquename);
        
        
    end
        


end




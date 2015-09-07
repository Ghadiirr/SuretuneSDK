wildcards = {'001','002','003','004','005','006','007','008','009','010','011','012','013','014','015','016','017','018','019','020','021'};
datasetchoice = [5,7];
excelCell = {'Patient','Side','C0','C1','C2','C3'};
excelCounter = 1;

% % User enters wildcard for session:
% wildcard = input('Get session from suretune that contains: ','s');

atlasColorIndex = SDK_colorpicker('Anatomy: ');
funcAtlasColorIndex = SDK_colorpicker('Atlas: ');


for iWildcard = 1:21%numel(wildcards)
%     if iWildcard==7;continue;end
    % Load Session to matlab
    S = Session;
    S.importfromsuretune(['*',wildcards{iWildcard},'*']);
    
    
    % % S = Session;
    % S.loadzip()
    
    
    %find the leads:
    [regNames,regTypes] = S.listregisterables;
    leadNames = regNames(ismember(regTypes,'Lead'));
    
    %prepare a bar for visualisation
    fvCube = createCube;
    faces = convhull(fvCube.vertices);
    vertices = fvCube.vertices; %center around origin.

    S.makemesh(vertices,faces,'bar.obj');
%     colormap('hsv')
    cmap = SDK_redgreencolormap;
    
    
    %Change some visualisation parameters
    atlasLeft = S.getregisterable('ID_AtlasLeft');
    atlasRight = S.getregisterable('ID_AtlasRight');
    funcAtlasLeft = S.getregisterable('ID_Left.FuncAtlas_BestResponders');
    funcAtlasRight = S.getregisterable('ID_Right.FuncAtlas_BestResponders');
%     funcAtlasLeft = S.getregisterable('ID_Left.FuncAtlas_PSM');
%     funcAtlasRight = S.getregisterable('ID_Right.FuncAtlas_PSM');

    
    atlasLeft.color=atlasColorIndex;%'#E6E6D8';
    atlasLeft.opacity = 0.5;
    atlasRight.color=atlasColorIndex;%'#E6E6D8';
    atlasRight.opacity = 0.5;
    
    funcAtlasLeft.color = funcAtlasColorIndex;% '#4DB8FF';
    funcAtlasLeft.threshold = 1500;
    funcAtlasLeft.opacity = 0.6;
    
    funcAtlasRight.color = funcAtlasColorIndex;%'#4DB8FF';
    funcAtlasRight.threshold = 1500;
    funcAtlasRight.opacity = 0.6;
    
    
    
    
    
    
    
    
    
    % for both leads:
    for iLead = 1:numel(leadNames)

        thisLead = S.getregisterable(leadNames{iLead});
        
        % add data to excel:
        excelCounter = excelCounter+1;
        excelCell{excelCounter,1} = wildcards{iWildcard};
        excelCell{excelCounter,2} = leadNames{iLead};

        
        % User selects AM
        disp('----------------------------------------------')
        disp(['Select the Aggregated map for',thisLead.label])
        AM = S.getregisterable(datasetchoice(iLead));
        
        
        %add a new structure for this lead
        contactPredictionStructure = S.addnewmesh('Contact prediction',1,thisLead,eye(4));
        
        % keep track of the scores per contact
        contactScores = zeros(1,4);
        for iContact = 0:3
            % for all conacts
            
            % render a stimulation field
            [x, y, z, scaledFieldDataV, isolevelV] = get3389vtavolume(1.5, iContact);
            [vnaFaces, vnaVertices] = isosurface(x, y, z, scaledFieldDataV, isolevelV);
            
            % bring stimulation field to atlas space
            transformationMatrix = S.gettransformfromto(thisLead,AM);
            fvVNA.vertices = SDK_transform3d(vnaVertices,transformationMatrix);
            fvVNA.faces = vnaFaces;
            
            
            
            
            %Use mesh voxelation to generate a binary volume in AM space
            [gridX,gridY,gridZ] = AM.volume.getlinspace;
            binaryVolume = VOXELISE(gridX,gridY,gridZ,fvVNA,'xyz');
            
            
            % compute the highest included value
            voxels = AM.volume.voxelArray;
            voxelsNormalized = voxels/max(voxels(:));
            includedVoxels = voxelsNormalized(binaryVolume);
            highestIncludedValue = max(includedVoxels(:)); %could be mulitple numbers
            try
                highestIncludedValue = highestIncludedValue(1); %take the first one.
            catch
                continue
            end
            
            
            contactScores(iContact+1) = highestIncludedValue;
            
            %Add highestIncludedValue to excel sheet:
            excelCell{excelCounter,iContact+3} = highestIncludedValue;
            
            % compute transformation matrices
            defaultGrayBarT = eye(4);
            defaultGrayBarT(1,1) = (1-highestIncludedValue)*5;
            defaultGrayBarT(2,2) = 1;
            defaultGrayBarT(3,3) = 1;
            defaultGrayBarT(1:3,4) = [0.5+5*highestIncludedValue;-0.5;iContact*2-0.5];
            
            predictionBarT = eye(4);
            predictionBarT(1,1) = 5*highestIncludedValue;
            predictionBarT(1:3,4) = [0.5;-0.5;iContact*2-0.5];
            
            % find rotation vector towards hot-spot
            distalPoint = SDK_transform3d([0 0 0],transformationMatrix);
            [num idx] = max(AM.volume.voxelArray(:));
            [x, y,z] = ind2sub(size(AM.volume.voxelArray),idx);
            hotspotPoint = [gridX(x),gridY(y),gridZ(z)];
            
            hotspotDirection = hotspotPoint - distalPoint;
            b = SDK_unitvector(distalPoint(1:2));
            a  = SDK_unitvector(hotspotPoint(1:2));
            angle = acos(a*b')+pi
            rotationMatrix = [cos(angle), -1*sin(angle), 0, 0;...
                sin(angle), cos(angle) , 0, 0;...
                0,0,1, 0;...
                0,0,0,1];
            
            
            
            % add bars to session
            colorDec = cmap(ceil(highestIncludedValue*63)+1,:);
            colorHex = SDK_rgb2hex(colorDec(:,:));
            predictionPart = contactPredictionStructure.addnewpart(['contact',num2str(iContact)],colorHex,1,rotationMatrix*predictionBarT,'bar.obj');
            contactPredictionStructure.addnewpart(['contact',num2str(iContact),'_gray'],'#888888',0.4,rotationMatrix*defaultGrayBarT,'bar.obj')
            
            predictionPart.diffuseLightingLevel = 0.7;
            predictionPart.specularLightingLevel = 0;
            predictionPart.ambientLightingLevel = 0.2;
            
        end
        
        %compute the best contact(s)
        i= find(contactScores==max(contactScores));
        iContact = i-1;
        
        if numel(iContact) > 1
            hotspotLeadSpace = SDK_transform3d(hotspotPoint,inv(transformationMatrix));  %convert hotspot point to lead space
            iContact = round(hotspotLeadSpace(3)/2);
        end
        
        bestScoreT = eye(4);
        bestScoreT(1,1) = 4.99+1.5+0.25;
        bestScoreT(2,2) = 0.002;
        bestScoreT(3,3) = 1.5;
        bestScoreT(1:3,4) = [0.5-1.5;0;iContact*2-0.75];
        contactPredictionStructure.addnewpart(['contact',num2str(iContact),'_bestContact'],'#ffffff',0.5,rotationMatrix*bestScoreT,'bar.obj')
        excelCell{excelCounter,7} = iContact;
        
        
        
        
    end
    
    S.import2suretune
end
% Send session back to suretune

xlswrite('contactRanking2.xls',excelCell)
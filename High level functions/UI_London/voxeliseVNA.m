
function nii = voxeliseVNA(S, datasetId,stimplan)

NeuronSize = 'Medium';



dataset = S.getregisterable(datasetId);  




     
    %thisStimplan belongs to lead:
    thisLead = stimplan.lead;
    
    %get transformation matrix from leadspace to T2 space
    T  = S.gettransformfromto(thisLead,dataset);
    
    %get the VTA for middle-sized neurons
    vna = stimplan.vta.(NeuronSize);
    
    
    %Convert VTA-volume to FV
    [x,y,z] = vna.getmeshgrid;
    voxelArray = vna.voxelArray;
    fv = isosurface(x,y,z,voxelArray,0.5);
    
    %transform the coordinates of the vertices
%     verts = [fv.vertices,ones(size(fv.vertices,1),1)];
%     vertsT2Space = verts*T; %row multiplication, so transposed T
    fv.vertices = SDK_transform3d(fv.vertices,T);%vertsT2Space(:,1:3);
    
    
    %Use mesh voxelation to generate a binary volume in T2 space
    [gridX,gridY,gridZ] = dataset.volume.getlinspace;
    [gridOUTPUT] = VOXELISE(gridX,gridY,gridZ,fv,'xyz');
    
    
    
      

    %gridOUTPUT should be flipped left<->right and anterior<->superior
    gridOUTPUT = flip(gridOUTPUT,1);
    gridOUTPUT = flip(gridOUTPUT,2);

    
    %make a niftii
        nii = make_nii(uint8(gridOUTPUT)*2^8-1,...
                    dataset.volume.volumeInfo.spacing,...
                    dataset.volume.volumeInfo.origin,...
                    [],...
                    stimplan.annotation);
                
                
                
                
                


    
end



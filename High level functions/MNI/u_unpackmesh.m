
function voxels = u_voxeliseMESH(S, datasetId,Registerable)

dataset = S.getregisterable(datasetId);  


   
    
 
     
    switch class(Registerable)
        case 'ImageBasedStructureSegmentation'
            T  = S.gettransformfromto(Registerable,dataset);
            mesh = Registerable.computeobj;
        case 'ManualStructureSegmentation'
            T  = S.gettransformfromto(Registerable,dataset);
            mesh = Registerable.getmesh;
        case 'ObjFile'
            T = eye(4); %Make sure it's already in the right space.
            mesh.v = Registerable.Vertices;
            mesh.f = Registerable.Faces;
    end
    fv.vertices = mesh.v;
    fv.faces = mesh.f;
    
    %transform the coordinates of the vertices
%     verts = [fv.vertices,ones(size(fv.vertices,1),1)];
%     vertsT2Space = verts*T; %row multiplication, so transposed T
    fv.vertices = SDK_transform3d(fv.vertices,T);%vertsT2Space(:,1:3);
    
    
    %Use mesh voxelation to generate a binary volume in T2 space
    [gridX,gridY,gridZ] =dataset.volume.getlinspace;
    [voxels] = VOXELISE(gridX,gridY,gridZ,fv,'xyz');
    
   

 
                
                
                
                


    
end



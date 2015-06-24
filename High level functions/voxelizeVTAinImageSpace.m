S = Session;
S.importfromsuretune('*01*')
% S.getSessionFromDicom('session1.dcm')


%Get the volume of activation in T2 Space
dataset = S.getregisterable;  %I know that the T2 image is the second registerable in the session.

%Get the stimulation plans
stimplanlist = S.therapyPlanStorage;




for iStimPlan = 1:numel(stimplanlist)
    thisStimPlan = stimplanlist{iStimPlan};
    
    %thisStimplan belongs to lead:
    thisLead = thisStimPlan.lead;
    
    %get transformation matrix from leadspace to T2 space
    [T]  = S.gettransformfromto(thisLead,dataset);
    
    %get the VTA for middle-sized neurons
    indexOfMediumAxons = 2;
    vta = thisStimPlan.vta.list{indexOfMediumAxons};
    
    
    %Convert VTA-volume to F annd V
    [x,y,z] = vta.getmeshgrid;
    voxelArray = vta.voxelArray;
    fv = isosurface(x,y,z,voxelArray,0.5);
    
    %transform the coordinates of the vertices
    verts = [fv.vertices,ones(size(fv.vertices,1),1)];
    vertsT2Space = verts*T; %row multiplication, so transposed T
    fv.vertices = vertsT2Space(:,1:3);
    
    
    %Use mesh voxelation to generate a binary volume in T2 space
    [gridX,gridY,gridZ] = dataset.volume.getlinspace;
    [gridOUTPUT] = VOXELISE(gridX,gridY,gridZ,fv,'xyz');
    
    %Make a new volume with this data
    t2VolumeInfo = dataset.volume.volumeInfo; %take the volumeInfo from the t2dataset
    t2VolumeInfo.id = 'VTAinCT'; %change the Id
    v = Volume;  
    v.newvolume(t2VolumeInfo,gridOUTPUT,S)  %
    
    %add thumbmnail
    import = load('thumbnail');
    v.thumbnail = import.thumbnail;

    
    %add the Volume to the Session
    T = S.gettransformfromto(dataset.matlabId,'Dataset0');
    S.addnewdataset('VTAinCT','VTAinCT','VTAinCT',[],'Dataset0',T,v)
    
     S.import2suretune
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end
    


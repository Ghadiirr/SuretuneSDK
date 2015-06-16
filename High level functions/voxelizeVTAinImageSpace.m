S = Session;
S.getSessionFromSureTune('*01*')
% S.getSessionFromDicom('session1.dcm')


%Get the volume of activation in T2 Space
dataset = S.getReg;  %I know that the T2 image is the second registerable in the session.

%Get the stimulation plans
stimplanlist = S.TherapyPlans;




for stimplanindex = 1:numel(stimplanlist)
    thisStimPlan = stimplanlist{stimplanindex};
    
    %thisStimplan belongs to lead:
    thisLead = thisStimPlan.Lead;
    
    %get transformation matrix from leadspace to T2 space
    [T]  = S.getTfromto(thisLead,dataset);
    
    %get the VTA for middle-sized neurons
    indexOfMediumAxons = 2;
    VTA = thisStimPlan.VTA.list{indexOfMediumAxons};
    
    
    %Convert VTA-volume to F annd V
    [x,y,z] = VTA.getMeshgrid;
    voxelArray = VTA.VoxelArray;
    fv = isosurface(x,y,z,voxelArray,0.5);
    
    %transform the coordinates of the vertices
    verts = [fv.vertices,ones(size(fv.vertices,1),1)];
    vertsT2Space = verts*T; %row multiplication, so transposed T
    fv.vertices = vertsT2Space(:,1:3);
    
    
    %Use mesh voxelation to generate a binary volume in T2 space
    [gridX,gridY,gridZ] = dataset.volume.getLinspace;
    [gridOUTPUT] = VOXELISE(gridX,gridY,gridZ,fv,'xyz');
    
    %Make a new volume with this data
    t2VolumeInfo = dataset.volume.VolumeInfo; %take the volumeInfo from the t2dataset
    t2VolumeInfo.Id = 'VTAinCT'; %change the Id
    v = Volume;  
    v.newVolume(t2VolumeInfo,gridOUTPUT,S)  %
    
    %add thumbmnail
    import = load('thumbnail');
    v.Thumbnail = import.thumbnail;

    
    %add the Volume to the Session
    T = S.getTfromto(dataset.MATLABid,'Dataset0');
    S.addNewDataset('VTAinCT','VTAinCT','VTAinCT',[],'Dataset0',T,v)
    
     S.import2SureTune
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end
    


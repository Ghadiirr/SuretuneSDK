function DatasetOut = SDK_duplicateDataset(DatasetIn)

    %get the session
    session = DatasetIn.session;
    
    %make new volume
    VolumeIn= DatasetIn.volume;
    NewVolume = Volume;
    NewVolumeInfo = VolumeIn.volumeInfo;
    NewVolumeInfo.id = [DatasetIn.volumeId ,'_copy'];
    
    NewVolume.newvolume(NewVolumeInfo,VolumeIn.voxelArray,session)
%     NewVolume.linktosession(session);
    
    %make new dataset    
    DatasetOut = session.addnewdataset([DatasetIn.label,'_copy'],[NewVolumeInfo.id],[NewVolumeInfo.id],[],DatasetIn.parent,DatasetIn.transform,NewVolume);

end
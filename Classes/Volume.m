classdef Volume <handle
    %VOLUME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        VoxelArray
        VolumeInfo
        Thumbnail
    end
    
    properties (Hidden = true)
        Unsaved = 1;
        Session
    end
        methods
            
            function Obj = Volume()
                
                I.Id = 'NoId';
                I.Dimensions = [0 0 0];
                I.Spacing = [0 0 0];
                I.Origin = [0 0 0];
                I.RescaleSlope = 0;
                I.RescaleIntercept = 0;
                I.ScanDirection = '';
                I.imageType = '';
                I.seriesNumber=0;
                I.Modality = '';
                I.Name = '';
                I.patientID = '';
                I.Gender = 'Unknown';
                
                
                Obj.VolumeInfo = I;
                Obj.VoxelArray = [];
                Obj.Thumbnail = [];
            end
            
            function newVolume(obj,VolumeInfo,VoxelArray,Session)
                obj.VolumeInfo = VolumeInfo;
                obj.VoxelArray = VoxelArray;
                obj.Session = Session;
            end
            
            
            function loadVolume(obj,pathName)
                thisdir = pwd;
                 %set unsaved to 0, because the volume is not created within
                %MATLAB
                obj.Unsaved = 0;
                
                if nargin == 1
                    
                    %ask user for directory
                    [pathName] = uigetdir();
                    if not(pathName)
                        disp('Aborted by user')
                        return
                    end
                elseif nargin ~= 2
                    error('Invalid Input')
                end
                
                
                %load xml
                xml = SDK_xml2struct([pathName,'\VolumeInfo.xml']);
                
                % Check for any comments (they may obstruct XML parsing
                if SDK_removeComments(pathName,'\VolumeInfo.xml');
                    %repeat reading with new file
                    fileName = '\VolumeInfo_nocomments.xml';
                    xml = SDK_xml2struct([pathName,fileName]);
                    disp('removed comments')
                end
                
                
                %extract data from xml:
                I.Id = xml.Volume.volumeInfo.VolumeInfo.volumeIdentifier.Attributes.value;
                I.Dimensions = [str2num(xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.nx.Attributes.value),...
                    str2num(xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.ny.Attributes.value),...
                    str2num(xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.nz.Attributes.value)];
                I.Spacing = [str2num(xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sx.Attributes.value),...
                    str2num(xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sy.Attributes.value),...
                    str2num(xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sz.Attributes.value)];
                I.Origin = SDK_Point3D2vector(xml.Volume.volumeInfo.VolumeInfo.origin.Point3D);
                I.RescaleSlope = xml.Volume.volumeInfo.VolumeInfo.rescaleSlope.Attributes.value;
                I.RescaleIntercept =xml.Volume.volumeInfo.VolumeInfo.rescaleIntercept.Attributes.value;
                I.ScanDirection = xml.Volume.volumeInfo.VolumeInfo.scanDirection.Enum.Attributes.value;
                I.imageType = xml.Volume.volumeInfo.VolumeInfo.imageType.Enum.Attributes.value;
                try
                I.seriesNumber= xml.Volume.seriesInfo.SeriesInfo.seriesNumber.Attributes.value;
                I.Modality = xml.Volume.seriesInfo.SeriesInfo.modality.Attributes.value;
                I.Name = xml.Volume.patientInfo.PatientInfo.name.Attributes.value;
                I.patientID = xml.Volume.patientInfo.PatientInfo.patientID.Attributes.value;
                I.Gender = xml.Volume.patientInfo.PatientInfo.gender.Enum.Attributes.value;
                catch
                    I.seriesNumber = [];
                    I.Modality = [];
                    I.Name = [];
                    I.patientID = [];
                    I.Gender = [];
                end
                
                obj.VolumeInfo = I;
                
               
                
                
                %Read voxelarray
                fid = fopen([pathName,'/VoxelArray.bin']);
                file = fread(fid, 'uint16');
                fclose(fid);
                
                %reshape according to volumeinfo
                obj.VoxelArray = reshape(file,[I.Dimensions(1),I.Dimensions(2),I.Dimensions(3)]);
                
                %check if thumbnail exists:
                if exist([pathName,'/Thumbnail.png'],'file' ) ~= 2
                    import = load('thumbnail.mat');
                    obj.Thumbnail=import.thumbnail;
                                     
                end
                
                
                
                
                
            end
                
            function saveToFolder(obj,folder)
                if ~obj.Unsaved;return;end;
                
                %save the voxel array
                [~,~] = mkdir(folder);
                fid = fopen([folder,'/VoxelArray.bin'],'w+');
                fwrite(fid, obj.VoxelArray, 'uint16');
                fclose(fid);
                
                %generate XML
                XML = ExportXML(obj);
                SDK_Session2XML(XML,[folder,'/VolumeInfo.xml'])
                
                %save thumbnail
                imwrite(obj.Thumbnail,[folder,'/Thumbnail.png'],'png')
                
                
                
                
                
                
            end
            
            
                function XML = ExportXML(obj)
                    
                    I = obj.VolumeInfo;
                    
                    
                    V.volumeIdentifier.Attributes.type = 'String';
                    V.volumeIdentifier.Attributes.value = I.Id;
                    
                    %Dimensions
                    V.dimension.Dimensions3d.nx.Attributes.type='Int';
                    V.dimension.Dimensions3d.nx.Attributes.value=I.Dimensions(1);
                    
                    V.dimension.Dimensions3d.ny.Attributes.type='Int';
                    V.dimension.Dimensions3d.ny.Attributes.value=I.Dimensions(2);
                    
                    V.dimension.Dimensions3d.nz.Attributes.type='Int';
                    V.dimension.Dimensions3d.nz.Attributes.value=I.Dimensions(3);
                    
                    %Spacing
                    V.spacing.Spacing3d.sx.Attributes.type='Double';
                    V.spacing.Spacing3d.sx.Attributes.value=I.Spacing(1);
                    
                    V.spacing.Spacing3d.sy.Attributes.type='Double';
                    V.spacing.Spacing3d.sy.Attributes.value=I.Spacing(2);
                    
                    V.spacing.Spacing3d.sz.Attributes.type='Double';
                    V.spacing.Spacing3d.sz.Attributes.value=I.Spacing(3);
                    
                    %Origin
                    V.origin.Point3D.Attributes.x=I.Origin(1);
                    V.origin.Point3D.Attributes.y=I.Origin(2);
                    V.origin.Point3D.Attributes.z=I.Origin(3);
                    
                    %RescaleSlope/Intercept
                    V.rescaleSlope.Attributes.type='Double';
                    V.rescaleSlope.Attributes.value = I.RescaleSlope;
                    
                    
                    V.rescaleIntercept.Attributes.type='Double';
                    V.rescaleIntercept.Attributes.value = I.RescaleIntercept;
                    
                    %ScanDirection
                    V.scanDirection.Enum.Attributes.type='ScanDirection';
                    V.scanDirection.Enum.Attributes.value = 'Axial';
                    
                    %PatientOrientation
                    V.patientOrientationX.Vector3D.Attributes.x = '1';
                    V.patientOrientationX.Vector3D.Attributes.y = '0';
                    V.patientOrientationX.Vector3D.Attributes.z = '0';
                    
                    V.patientOrientationY.Vector3D.Attributes.x = '0';
                    V.patientOrientationY.Vector3D.Attributes.y = '1';
                    V.patientOrientationY.Vector3D.Attributes.z = '0';
                    
                    %ImageType
                    V.imageType.Enum.Attributes.type = 'ImageType';
                    V.imageType.Enum.Attributes.value = 'MR';
                    
                    %instanceNumbers
                    V.instanceNumbers.IntArray.Text = 1;
                    
                    %acquisitionDatetime
                    V.acquisitionDateTime.Attributes.type = 'DateTime';
                    V.acquisitionDateTime.Attributes.value = [SDK_datestr8601(clock,'*ymdHMS'),'.0000000'];
                    
                    
                    V.generationRecipe.Attributes.type = 'String';
                    V.generationRecipe.Attributes.value = 'MATLAB SDK';
                    
                    %%%SeriesInfo
                    S.seriesDate.Null = [];
                    
                    S.seriesNumber.Attributes.type = 'Int';
                    S.seriesNumber.Attributes.value = '0';
                    
                    S.seriesDescription.Null =[];
                    
                    S.modality.Attributes.type = 'String';
                    S.modality.Attributes.value = 'MR';
                    
                    S.studyDate.Attributes.type = 'DateTime';
                    S.studyDate.Attributes.value = [SDK_datestr8601(clock,'*ymdHMS'),'.0000000'];
                    
                    S.studyDescription.Attributes.type = 'String';
                    S.studyDescription.Attributes.value = 'This volume was added by MATLAB';
                    S.studyInstanceUid.Attributes.type = 'String';
                    S.studyInstanceUid.Attributes.value = 'MATLAB import';    %Nummer generator 
                    S.seriesInstanceUid.Attributes.type = 'String';
                    S.seriesInstanceUid.Attributes.value = strrep(datestr(datetime),' ','_');
                    S.frameOfReferenceUid.Attributes.type = 'String';
                    S.frameOfReferenceUid.Attributes.value = 'Unknown';
                    
                    %%%patientinfo
                    p.name.Attributes.type = 'String';
                    p.name.Attributes.value = '';
                    p.patientID.Attributes.type = 'String';
                    p.patientID.Attributes.value = '';
                    
                    p.dateOfBirth.Null  = [];
                    
                    p.gender.Enum.Attributes.type = 'GenderType';
                    p.gender.Enum.Attributes.value = 'Unknown';
                    
                    
                    XML.Volume.volumeInfo.VolumeInfo = V;
                    XML.Volume.seriesInfo.SeriesInfo = S;
                    XML.Volume.patientInfo.PatientInfo = p;
                    
                    
                end
                
                function [x,y,z] = getMeshgrid(obj)
                        Dimensions = obj.VolumeInfo.Dimensions;
                        Spacing = obj.VolumeInfo.Spacing;
                        Origin = obj.VolumeInfo.Origin;

                        [x,y,z] = meshgrid(Origin(1):Spacing(1):Origin(1)+(Dimensions(1)-1)*Spacing(1),...
                            Origin(2):Spacing(2):Origin(2)+(Dimensions(2)-1)*Spacing(2),...
                            Origin(3):Spacing(3):Origin(3)+(Dimensions(3)-1)*Spacing(3));
                    
                end
                
                function [x,y,z] = getLinspace(obj)
                     Dimensions = obj.VolumeInfo.Dimensions;
                        Spacing = obj.VolumeInfo.Spacing;
                        Origin = obj.VolumeInfo.Origin;

                       x = [Origin(1):Spacing(1):Origin(1)+(Dimensions(1)-1)*Spacing(1)];
                         y =    [Origin(2):Spacing(2):Origin(2)+(Dimensions(2)-1)*Spacing(2)];
                           z =  [Origin(3):Spacing(3):Origin(3)+(Dimensions(3)-1)*Spacing(3)];
                end
                
                
                
                function LinkToSession(obj,Session)
                    obj.Session = Session;
                end
                
                
                function BB = getBoundingBox(obj)
                    O = obj.VolumeInfo.Origin;
                    S = obj.VolumeInfo.Spacing;
                    D = obj.VolumeInfo.Dimensions;
                    
                    maxBB = O+S.*D;
                    
                    BB = [O;maxBB]';
                end
                    
                    
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            end
            
        end
        

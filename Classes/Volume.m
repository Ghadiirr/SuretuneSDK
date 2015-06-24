classdef Volume <handle
    %VOLUME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        voxelArray
        volumeInfo
        thumbnail
    end
    
    properties (Hidden = true)
        unsaved = 1;
        session
    end
    methods
        
        function Obj = Volume()
            
            I.id = 'Noid';
            I.dimensions = [0 0 0];
            I.spacing = [0 0 0];
            I.origin = [0 0 0];
            I.rescaleSlope = 0;
            I.rescaleIntercept = 0;
            I.scanDirection = '';
            I.imageType = '';
            I.seriesNumber=0;
            I.modality = '';
            I.name = '';
            I.patientId = '';
            I.gender = 'Unknown';
            
            
            Obj.volumeInfo = I;
            Obj.voxelArray = [];
            Obj.thumbnail = [];
        end
        
        function newvolume(obj,volumeInfo,voxelArray,session)
            obj.volumeInfo = volumeInfo;
            obj.voxelArray = voxelArray;
            obj.session = session;
        end
        
        
        function loadvolume(obj,pathname)
            thisdir = pwd;
            %set unsaved to 0, because the volume is not created within
            %MATLAB
            obj.unsaved = 0;
            
            if nargin == 1
                
                %ask user for directory
                [pathname] = uigetdir();
                if not(pathname)
                    disp('Aborted by user')
                    return
                end
            elseif nargin ~= 2
                error('Invalid Input')
            end
            
            
            %load xml
            xml = SDK_xml2struct([pathname,'\volumeInfo.xml']);
            
            % Check for any comments (they may obstruct XML parsing
            if SDK_removecomments(pathname,'\volumeInfo.xml');
                %repeat reading with new file
                filename = '\volumeInfo_nocomments.xml';
                xml = SDK_xml2struct([pathname,filename]);
                disp('removed comments')
            end
            
            
            %extract data from xml:
            I.id = xml.Volume.volumeInfo.VolumeInfo.volumeIdentifier.Attributes.value;
            I.dimensions = [str2num(xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.nx.Attributes.value),...
                str2num(xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.ny.Attributes.value),...
                str2num(xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.nz.Attributes.value)];
            I.spacing = [str2num(xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sx.Attributes.value),...
                str2num(xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sy.Attributes.value),...
                str2num(xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sz.Attributes.value)];
            I.origin = SDK_point3d2vector(xml.Volume.volumeInfo.VolumeInfo.origin.Point3D);
            I.rescaleSlope = xml.Volume.volumeInfo.VolumeInfo.rescaleSlope.Attributes.value;
            I.rescaleIntercept =xml.Volume.volumeInfo.VolumeInfo.rescaleIntercept.Attributes.value;
            I.scanDirection = xml.Volume.volumeInfo.VolumeInfo.scanDirection.Enum.Attributes.value;
            I.imageType = xml.Volume.volumeInfo.VolumeInfo.imageType.Enum.Attributes.value;
            try
                I.seriesNumber= xml.Volume.seriesInfo.SeriesInfo.seriesNumber.Attributes.value;
                I.modality = xml.Volume.seriesInfo.SeriesInfo.modality.Attributes.value;
                I.name = xml.Volume.patientInfo.PatientInfo.name.Attributes.value;
                I.patientId = xml.Volume.patientInfo.PatientInfo.patientID.Attributes.value;
                I.gender = xml.Volume.patientInfo.PatientInfo.gender.Enum.Attributes.value;
            catch
                I.seriesNumber = [];
                I.modality = [];
                I.name = [];
                I.patientId = [];
                I.gender = [];
            end
            
            obj.volumeInfo = I;
            
            
            
            
            %Read voxelArray
            fid = fopen([pathname,'/voxelArray.bin']);
            file = fread(fid, 'uint16');
            fclose(fid);
            
            %reshape according to volumeInfo
            obj.voxelArray = reshape(file,[I.dimensions(1),I.dimensions(2),I.dimensions(3)]);
            
            %check if thumbnail exists:
            if exist([pathname,'/thumbnail.png'],'file' ) ~= 2
                import = load('thumbnail.mat');
                obj.thumbnail=import.thumbnail;
                
            end
            
            
            
            
            
        end
        
        function save2folder(obj,folder)
            if ~obj.unsaved;return;end;
            
            %save the voxel array
            [~,~] = mkdir(folder);
            fid = fopen([folder,'/voxelArray.bin'],'w+');
            fwrite(fid, obj.voxelArray, 'uint16');
            fclose(fid);
            
            %generate XML
            XML = exportxml(obj);
            SDK_session2xml(XML,[folder,'/volumeInfo.xml'])
            
            %save thumbnail
            imwrite(obj.thumbnail,[folder,'/thumbnail.png'],'png')
            
            
            
            
            
            
        end
        
        
        function XML = exportxml(obj)
            
            I = obj.volumeInfo;
            
            
            V.Volumeidentifier.Attributes.type = 'String';
            V.Volumeidentifier.Attributes.value = I.id;
            
            %dimensions
            V.Dimension.Dimensions3d.nx.Attributes.type='Int';
            V.Dimension.Dimensions3d.nx.Attributes.value=I.dimensions(1);
            
            V.Dimension.Dimensions3d.ny.Attributes.type='Int';
            V.Dimension.Dimensions3d.ny.Attributes.value=I.dimensions(2);
            
            V.Dimension.Dimensions3d.nz.Attributes.type='Int';
            V.Dimension.Dimensions3d.nz.Attributes.value=I.dimensions(3);
            
            %spacing
            V.Spacing.Spacing3d.sx.Attributes.type='Double';
            V.Spacing.Spacing3d.sx.Attributes.value=I.spacing(1);
            
            V.Spacing.Spacing3d.sy.Attributes.type='Double';
            V.Spacing.Spacing3d.sy.Attributes.value=I.spacing(2);
            
            V.Spacing.Spacing3d.sz.Attributes.type='Double';
            V.Spacing.Spacing3d.sz.Attributes.value=I.spacing(3);
            
            %origin
            V.Origin.Point3D.Attributes.x=I.origin(1);
            V.Origin.Point3D.Attributes.y=I.origin(2);
            V.Origin.Point3D.Attributes.z=I.origin(3);
            
            %rescaleSlope/Intercept
            V.RescaleSlope.Attributes.type='Double';
            V.RescaleSlope.Attributes.value = I.rescaleSlope;
            
            
            V.RescaleIntercept.Attributes.type='Double';
            V.RescaleIntercept.Attributes.value = I.rescaleIntercept;
            
            %scanDirection
            V.ScanDirection.Enum.Attributes.type='scanDirection';
            V.ScanDirection.Enum.Attributes.value = 'Axial';
            
            %PatientOrientation
            V.PatientOrientationX.Vector3D.Attributes.x = '1';
            V.PatientOrientationX.Vector3D.Attributes.y = '0';
            V.PatientOrientationX.Vector3D.Attributes.z = '0';
            
            V.PatientOrientationY.Vector3D.Attributes.x = '0';
            V.PatientOrientationY.Vector3D.Attributes.y = '1';
            V.PatientOrientationY.Vector3D.Attributes.z = '0';
            
            %ImageType
            V.ImageType.Enum.Attributes.type = 'ImageType';
            V.ImageType.Enum.Attributes.value = 'MR';
            
            %instanceNumbers
            V.InstanceNumbers.IntArray.Text = 1;
            
            %acquisitionDatetime
            V.AcquisitionDateTime.Attributes.type = 'DateTime';
            V.AcquisitionDateTime.Attributes.value = [SDK_datestr8601(clock,'*ymdHMS'),'.0000000'];
            
            
            V.GenerationRecipe.Attributes.type = 'String';
            V.GenerationRecipe.Attributes.value = 'MATLAB SDK';
            
            %%%SeriesInfo
            S.SeriesDate.Null = [];
            
            S.SeriesNumber.Attributes.type = 'Int';
            S.SeriesNumber.Attributes.value = '0';
            
            S.SeriesDescription.Null =[];
            
            S.Modality.Attributes.type = 'String';
            S.Modality.Attributes.value = 'MR';
            
            S.StudyDate.Attributes.type = 'DateTime';
            S.StudyDate.Attributes.value = [SDK_datestr8601(clock,'*ymdHMS'),'.0000000'];
            
            S.StudyDescription.Attributes.type = 'String';
            S.StudyDescription.Attributes.value = 'This volume was added by MATLAB';
            S.StudyInstanceUid.Attributes.type = 'String';
            S.StudyInstanceUid.Attributes.value = 'MATLAB import';    %Nummer generator
            S.SeriesInstanceUid.Attributes.type = 'String';
            S.SeriesInstanceUid.Attributes.value = strrep(datestr(datetime),' ','_');
            S.FrameOfReferenceUid.Attributes.type = 'String';
            S.FrameOfReferenceUid.Attributes.value = 'Unknown';
            
            %%%patientinfo
            p.Name.Attributes.type = 'String';
            p.Name.Attributes.value = '';
            p.PatientID.Attributes.type = 'String';
            p.PatientID.Attributes.value = '';
            
            p.DateOfBirth.Null  = [];
            
            p.Gender.Enum.Attributes.type = 'genderType';
            p.Gender.Enum.Attributes.value = 'Unknown';
            
            
            XML.Volume.volumeInfo.VolumeInfo = V;
            XML.Volume.seriesInfo.SeriesInfo = S;
            XML.Volume.patientInfo.PatientInfo = p;
            
            
        end
        
        function [x,y,z] = getmeshgrid(obj)
            dimensions = obj.volumeInfo.dimensions;
            spacing = obj.volumeInfo.spacing;
            origin = obj.volumeInfo.origin;
            
            [x,y,z] = meshgrid(origin(1):spacing(1):origin(1)+(dimensions(1)-1)*spacing(1),...
                origin(2):spacing(2):origin(2)+(dimensions(2)-1)*spacing(2),...
                origin(3):spacing(3):origin(3)+(dimensions(3)-1)*spacing(3));
            
        end
        
        function [x,y,z] = getlinspace(obj)
            dimensions = obj.volumeInfo.dimensions;
            spacing = obj.volumeInfo.spacing;
            origin = obj.volumeInfo.origin;
            
            x = [origin(1):spacing(1):origin(1)+(dimensions(1)-1)*spacing(1)];
            y =    [origin(2):spacing(2):origin(2)+(dimensions(2)-1)*spacing(2)];
            z =  [origin(3):spacing(3):origin(3)+(dimensions(3)-1)*spacing(3)];
        end
        
        
        
        function linktosession(obj,session)
            obj.session = session;
        end
        
        
        function BB = getboundingbox(obj)
            O = obj.volumeInfo.origin;
            S = obj.volumeInfo.spacing;
            D = obj.volumeInfo.dimensions;
            
            maxBB = O+S.*D;
            
            BB = [O;maxBB]';
        end
        
        function exportnifti(obj)
            img = obj.voxelArray;
            voxel_size = obj.volumeInfo.spacing;
            origin = obj.volumeInfo.origin;
            
            nii = makenifti(img, voxel_size, origin, 4, obj.volumeInfo.patientId);
            %                     thisdir = pwd;
            
            exportfolder = obj.session.exportFolder;
            cd(exportfolder)
            name = ['nii_',obj.volumeInfo.id];
            [~,~]=mkdir(name)
            cd(name)
            save_nii(nii,name)
            
            
            
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    end
    
end


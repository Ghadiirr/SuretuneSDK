classdef Volume <handle_hidden
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
            if nargin<4
                disp('newvolume([obj],volumeInfo,voxelArray,session)')
                disp('If volumeInfo is not [], blanc volumeInfo structure is replaced')
                return
            end
            if ~isempty(volumeInfo)
                obj.volumeInfo = volumeInfo;
            end
            obj.voxelArray = voxelArray;
            if ~isempty(session)
                obj.linktosession(session)
            end
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
        
        function savetofolder(obj,folder)
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
            
            
            V.volumeIdentifier.Attributes.type = 'String';
            V.volumeIdentifier.Attributes.value = I.id;
            
            %dimensions
            V.dimension.Dimensions3d.nx.Attributes.type='Int';
            V.dimension.Dimensions3d.nx.Attributes.value=I.dimensions(1);
            
            V.dimension.Dimensions3d.ny.Attributes.type='Int';
            V.dimension.Dimensions3d.ny.Attributes.value=I.dimensions(2);
            
            V.dimension.Dimensions3d.nz.Attributes.type='Int';
            V.dimension.Dimensions3d.nz.Attributes.value=I.dimensions(3);
            
            %spacing
            V.spacing.Spacing3d.sx.Attributes.type='Double';
            V.spacing.Spacing3d.sx.Attributes.value=I.spacing(1);
            
            V.spacing.Spacing3d.sy.Attributes.type='Double';
            V.spacing.Spacing3d.sy.Attributes.value=I.spacing(2);
            
            V.spacing.Spacing3d.sz.Attributes.type='Double';
            V.spacing.Spacing3d.sz.Attributes.value=I.spacing(3);
            
            %origin
            V.origin.Point3D.Attributes.x=I.origin(1);
            V.origin.Point3D.Attributes.y=I.origin(2);
            V.origin.Point3D.Attributes.z=I.origin(3);
            
            %rescaleSlope/Intercept
            V.rescaleSlope.Attributes.type='Double';
            V.rescaleSlope.Attributes.value = I.rescaleSlope;
            
            
            V.rescaleIntercept.Attributes.type='Double';
            V.rescaleIntercept.Attributes.value = I.rescaleIntercept;
            
            %scanDirection
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
            obj.session.volumeStorage.list{end+1} = obj;
            obj.session.volumeStorage.names{end+1} = obj.volumeInfo.id;
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
            
            if  isempty(obj.session)
                warning('Volume Object is not linked to a session. In order to save, please select a directory')
                exportfolder = uigetdir();
            else
                exportfolder = obj.session.exportFolder;
            end
            cd(exportfolder)
            name = ['nii_',obj.volumeInfo.id];
            [~,~]=mkdir(name)
            cd(name)
            save_nii(nii,name)
            
            
            
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    end
    
end


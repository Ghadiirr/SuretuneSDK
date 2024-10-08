classdef Volume <handle_hidden
    %VOLUME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        voxelArray
        volumeInfo
        thumbnail
    end
    
    properties (Hidden = true)
        modified = 1;
        seriesInfo
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
            I.dateofbirth = [];
            I.gender = 'Unknown';
            
            
            Obj.volumeInfo = I;
            Obj.voxelArray = [];
            Obj.thumbnail = imread('Thumbnail.png');
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
            obj.modified = 0;
            
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
            
            fullFileName = fullfile(pwd,pathname,'VolumeInfo.xml');
            % Check for any comments (they may obstruct XML parsing
            if SDK_removecomments(fullFileName);
                %repeat reading with new file
                filename = 'VolumeInfo_nocomments.xml';
                xml = SDK_xml2struct(fullfile(pwd,pathname,filename));
            else
                xml = SDK_xml2struct(fullfile(pwd,pathname,'VolumeInfo.xml'));
                %                 disp('removed comments')
            end
            
            
            %extract data from xml:
            I.id = xml.Volume.volumeInfo.VolumeInfo.volumeIdentifier.Attributes.value;
            I.dimensions = str2num([xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.nx.Attributes.value ','...
                xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.ny.Attributes.value ','...
                xml.Volume.volumeInfo.VolumeInfo.dimension.Dimensions3d.nz.Attributes.value]); %#ok<ST2NM>
            I.spacing = str2num([xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sx.Attributes.value ','...
                xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sy.Attributes.value ','...
                xml.Volume.volumeInfo.VolumeInfo.spacing.Spacing3d.sz.Attributes.value]); %#ok<ST2NM>
            I.origin = SDK_point3d2vector(xml.Volume.volumeInfo.VolumeInfo.origin.Point3D);
            I.rescaleSlope = xml.Volume.volumeInfo.VolumeInfo.rescaleSlope.Attributes.value;
            I.rescaleIntercept =xml.Volume.volumeInfo.VolumeInfo.rescaleIntercept.Attributes.value;
            I.scanDirection = xml.Volume.volumeInfo.VolumeInfo.scanDirection.Enum.Attributes.value;
            I.imageType = xml.Volume.volumeInfo.VolumeInfo.imageType.Enum.Attributes.value;
            I.generateionRecipe = xml.Volume.volumeInfo.VolumeInfo.generationRecipe;
            I.acquisitionDateTime = trytoget('xml.Volume.volumeInfo.VolumeInfo.acquisitionDateTime.Attributes.value','1900-01-01T00:00:00.0000000');
            I.instanceNumbers = trytoget('xml.Volume.volumeInfo.VolumeInfo.instanceNumbers.IntArray.Text');
            I.seriesNumber= trytoget('xml.Volume.seriesInfo.SeriesInfo.seriesNumber.Attributes.value');
            I.modality = trytoget('xml.Volume.seriesInfo.SeriesInfo.modality.Attributes.value');
            
            if isfield(xml.Volume.patientInfo,'Patient')
                I.name = trytoget('xml.Volume.patientInfo.Patient.name.Attributes.value');
                I.patientId = trytoget('xml.Volume.patientInfo.Patient.patientID.Attributes.value');
                I.gender = trytoget('xml.Volume.patientInfo.Patient.gender.Enum.Attributes.value');
                I.dateofbirth = trytoget('xml.Volume.patientInfo.Patient.dateOfBirth.Attributes.value','1900-01-01T00:00:00.0000000');
            else
                I.name = trytoget('xml.Volume.patientInfo.PatientInfo.name.Attributes.value');
                I.patientId = trytoget('xml.Volume.patientInfo.PatientInfo.patientID.Attributes.value');
                I.gender = trytoget('xml.Volume.patientInfo.PatientInfo.gender.Enum.Attributes.value');
                I.dateofbirth = trytoget('xml.Volume.patientInfo.PatientInfo.dateOfBirth.Attributes.value','1900-01-01T00:00:00.0000000');
            end
            
            obj.volumeInfo = I;
            
            if isfield(xml.Volume.seriesInfo,'SeriesInfo')
                obj.seriesInfo = xml.Volume.seriesInfo.SeriesInfo;
            else
                obj.seriesInfo = [];
            end
            
            
            
            
            
            %Also read the remaining bits:
            
            
            
            
            
            %Read voxelArray
            fid = fopen(fullfile(pathname,'VoxelArray.bin'));
            file = fread(fid, 'uint16');
            fclose(fid);
            
            %reshape according to volumeInfo
            obj.voxelArray = reshape(file,I.dimensions);
            
            %check if thumbnail exists:
            if exist(fullfile(pathname,'Thumbnail.png'),'file' )==2
                obj.thumbnail = imread(fullfile(pathname,'Thumbnail.png'));
            else
                import = load('thumbnail.mat');
                obj.thumbnail=import.thumbnail;
                
            end
            
            
            function value = trytoget(inputstring, default)
                if nargin ==1
                    default = [];
                end
                try value = eval(inputstring);
                catch
                    value = default;
                end
            end
            
            
            
            
        end
        
        function savetofolder(obj,folder)
            %             if ~obj.modified;
            %                 return;
            %             end;
            
            %save the voxel array
            [~,~] = mkdir(folder);
            fid = fopen(fullfile(folder,'VoxelArray.bin'),'w+');
            try
                fwrite(fid, obj.voxelArray, 'uint16');
            catch
                warning('cannot write')
            end
            fclose(fid);
            
            %generate XML
            XML = exportxml(obj);
            SDK_session2xml(XML,fullfile(folder,'VolumeInfo.xml'))
            
            %save thumbnail
            imwrite(obj.thumbnail,fullfile(folder,'Thumbnail.png'),'png')
            
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
            V.scanDirection.Enum.Attributes.value = I.scanDirection;
            
            %PatientOrientation
            V.patientOrientationX.Vector3D.Attributes.x = '1';
            V.patientOrientationX.Vector3D.Attributes.y = '0';
            V.patientOrientationX.Vector3D.Attributes.z = '0';
            
            V.patientOrientationY.Vector3D.Attributes.x = '0';
            V.patientOrientationY.Vector3D.Attributes.y = '1';
            V.patientOrientationY.Vector3D.Attributes.z = '0';
            
            %ImageType
            V.imageType.Enum.Attributes.type = 'ImageType';
            V.imageType.Enum.Attributes.value = I.imageType;
            
            %instanceNumbers
            V.instanceNumbers.IntArray.Text = I.instanceNumbers ;
            
            %acquisitionDatetime
            V.acquisitionDateTime.Attributes.type = 'DateTime';
            V.acquisitionDateTime.Attributes.value = I.acquisitionDateTime; %[SDK_datestr8601(clock,'*ymdHMS'),'.0000000'];
            
            
            V.generationRecipe.Attributes.type = 'String';
            V.generationRecipe.Attributes.value = '';
            
            %%%SeriesInfo
            if ~isempty(obj.seriesInfo)
                S = obj.seriesInfo;
            else
                S.seriesDate.Null = [];
                
                S.seriesNumber.Attributes.type = 'Int';
                S.seriesNumber.Attributes.value = '0';
                
                S.seriesDescription.Null =[];
                
                S.modality.Attributes.type = 'String';
                S.modality.Attributes.value = 'MR';
                
                S.studyDate.Attributes.type = 'DateTime';
                S.studyDate.Attributes.value = [SDK_datestr8601(clock,'*ymdHMS'),'.0000000'];
                
                S.studyDescription.Attributes.type = 'String';
                S.studyDescription.Attributes.value = 'MATLAB import';
                S.studyInstanceUid.Attributes.type = 'String';
                S.studyInstanceUid.Attributes.value = 'MATLAB import';    %Nummer generator
                S.seriesInstanceUid.Attributes.type = 'String';
                S.seriesInstanceUid.Attributes.value = strrep(datestr(datetime),' ','_');
                S.frameOfReferenceUid.Attributes.type = 'String';
                S.frameOfReferenceUid.Attributes.value = 'Unknown';
            end
            
            %%%patientinfo
            p.name.Attributes.type = 'String';
            p.name.Attributes.value = I.name;
            p.patientID.Attributes.type = 'String';
            p.patientID.Attributes.value = I.patientId;
            
            if ~isfield(I,'dateofbirth')
                p.dateOfBirth.Null  = [];
            else
                if isempty(I.dateofbirth)
                    p.dateOfBirth.Null  = [];
                else
                    p.dateOfBirth.Attributes.type='DateTime';
                    p.dateOfBirth.Attributes.value=I.dateofbirth;
                end
            end
            
            p.gender.Enum.Attributes.type = 'GenderType';
            p.gender.Enum.Attributes.value = I.gender;
            
            
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
        
        function [x,y,z] = getmeshgrid_yx(obj)
            dimensions = obj.volumeInfo.dimensions;
            spacing = obj.volumeInfo.spacing;
            origin = obj.volumeInfo.origin;
            
            [x,y,z] = meshgrid(origin(2):spacing(2):origin(2)+(dimensions(2)-1)*spacing(2),...
                origin(1):spacing(1):origin(1)+(dimensions(1)-1)*spacing(1),...
                origin(3):spacing(3):origin(3)+(dimensions(3)-1)*spacing(3));
        end
        
        function [x,y,z] = getndgrid(obj)
            dimensions = obj.volumeInfo.dimensions;
            spacing = obj.volumeInfo.spacing;
            origin = obj.volumeInfo.origin;
            
            [x,y,z] = ndgrid(origin(1):spacing(1):origin(1)+(dimensions(1)-1)*spacing(1),...
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
        
        
        function [x,y,z] = getlinspace_yx(obj)
            dimensions = obj.volumeInfo.dimensions;
            spacing = obj.volumeInfo.spacing;
            origin = obj.volumeInfo.origin;
            
            x =    [origin(2):spacing(2):origin(2)+(dimensions(2)-1)*spacing(2)];
            y = [origin(1):spacing(1):origin(1)+(dimensions(1)-1)*spacing(1)];
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
            
            BBmatrix = [O;maxBB]';
            
            BB.leftDown = BBmatrix(:,1);
            BB.rightUp = BBmatrix(:,2);
            
            
            
            
        end
        
        function nii = exportnifti(obj,varargin)
            img = obj.voxelArray;
            
            
            %rescale slope
            if ischar(obj.volumeInfo.rescaleSlope)
                slope = str2double(obj.volumeInfo.rescaleSlope);
            else
                slope = obj.volumeInfo.rescaleSlope;
            end
            
            if ischar(obj.volumeInfo.rescaleIntercept)
                intercept = str2double(obj.volumeInfo.rescaleIntercept);
            else
                intercept = obj.volumeInfo.rescaleIntercept;
            end
            img = img*slope+intercept;
            

            
            voxel_size = obj.volumeInfo.spacing;
            origin = obj.volumeInfo.origin;
            
            if (~exist('make_nii.m'))
                error('Nifti toolbox could not be found.')
            end
            
            %             DICOM: Left Anterior Superior
            %             NII: Right Posterior Superior
            
            
            %flip X
            img = flip(img,1);
            
            %flip Y
            img = flip(img,2);
            
%             %mirror origin
%             width = size(img).*voxel_size;
%             flippedorigin = width+2*origin;
%             origin(1:2) = flippedorigin(1:2);
            
            
            nii = make_nii(img, voxel_size, origin, 4, obj.volumeInfo.patientId);
            %add some more data in the header
            nii.hdr.dime.scl_slope = 0;%slope;
            nii.hdr.dime.scl_inter = 0;%intercept;
            
           LPS2RAS_originator = -1*(size(img).*voxel_size-voxel_size + nii.hdr.hist.originator(1:3));
           %  LPS2RAS_originator = -1*(size(img).*voxel_size           + nii.hdr.hist.originator(1:3));
            
            nii.hdr.hist.srow_x = [voxel_size(1) 0 0 LPS2RAS_originator(1)];
            nii.hdr.hist.srow_y = [0 voxel_size(2) 0 LPS2RAS_originator(2)];
            nii.hdr.hist.srow_z = [0 0 voxel_size(3) nii.hdr.hist.originator(3)];
            nii.hdr.hist.sform_code = 4;
            nii.hdr.dime.glmax = 0;
            
            
            nii.hdr.dime.vox_offset = 352;
            
            
            
            
            
            
            %                     thisdir = pwd;
            
            if  isempty(obj.session)
                warning('Volume Object is not linked to a session. In order to save, please select a directory')
                exportfolder = uigetdir();
            else
                exportfolder = obj.session.exportFolder;
            end
            
            if nargin==1
                cd(exportfolder)
                if strcmp(obj.volumeInfo.modality,'MR')
                    name = [obj.volumeInfo.imageType, obj.volumeInfo.scanDirection,'.nii'];
                    %                 name = 'anat.nii';
                elseif strcmp(obj.volumeInfo.modality,'CT')
                    name = [obj.volumeInfo.imageType, obj.volumeInfo.scanDirection,'.nii'];
                    %                 name = 'postop_ct.nii';
                end
                [~,~]=mkdir(obj.volumeInfo.patientId);
                cd(obj.volumeInfo.patientId)
                save_nii(nii,name)
            else
                totalpath = varargin{1};
                [exportdir,filename] = fileparts(totalpath);
                thisdir = pwd;
                cd(exportdir)
                save_nii(nii,[filename,'.nii'])
                cd(thisdir)
            end
            
            
            
            
            
            
        end
        
        
        function loadnifti(obj)
            [fileName,pathName] = uigetfile('*.nii','Select niftii file');
            nii = load_nii(fullfile(pathName,fileName));
            
            
            I.id = 'fileName';
            I.dimensions = nii.hdr.dime.dim(2:4);
            I.spacing = nii.hdr.dime.dim(2:4);
            I.origin = nii.hdr.hist.originator(1:3);
            I.rescaleSlope = 0;
            I.rescaleIntercept = 0;
            I.scanDirection = '';
            I.imageType = '';
            I.seriesNumber=0;
            I.modality = '';
            I.name = '';
            I.patientId = '';
            I.gender = 'Unknown';
            
            
            obj.volumeInfo = I;
            obj.voxelArray = nii.img;
            
        end
        
        function tvoxelindex = gettransformtovoxelindices(obj)
            % three actions:
            % - translate
            % - scale
            % - add one for the first index.
            scaling = diag(1./obj.volumeInfo.spacing);
            scaling(4,4) = 1;
            
            
            translationvector = obj.volumeInfo.origin.*-1';
            translation = eye(4,4);
            translation(1:3,4) = translationvector;
            
            plusone = eye(4);plusone(1:3,4) = [1;1;1];
            
            
            tvoxelindex = translation'*scaling'*plusone';
            
        end
        
        
        function croppedVolume = getcroppedvolume(obj,leftdown,rightup)
            if nargin == 2
                if isstruct(leftdown)
                    if isfield(leftdown,'leftDown') && isfield(leftdown,'rightUp')
                        struc = leftdown;
                        leftdown = struc.leftDown;
                        rightup  = struc.rightUp;
                    else
                        error('Invalid input: 1 input argument is only allowed if it is a boundingbox structure with fields ''leftDown'' and ''rightUp''. Otherwise give two vectors.')
                    end
                elseif size(leftdown)==[3,2]
                    array = leftdown;
                    leftdown  = array(:,1);
                    rightup = array(:,2);
                else
                    error('Invalid input: 1 input argument is only allowed if it is a boundingbox structure with fields ''leftDown'' and ''rightUp''. Otherwise give two vectors.')
                end
                
                
            end
            %if there are any numbers with a decimal, it is assumed
            %that it is a 3D coordinate that has to be converted to a
            %voxelindex
            
            if any(mod(leftdown,1)) || any(mod(rightup,1))
                leftdown_i = SDK_transform3d(leftdown,obj.gettransformtovoxelindices);
                rightup_i = SDK_transform3d(rightup,obj.gettransformtovoxelindices);
            else
                leftdown_i = leftdown;
                rightup_i = rightup;
            end
            
            
            
            all = [leftdown_i;rightup_i];
            all = sort(all);
            all(1,:) = floor(all(1,:));
            all(2,:) = ceil(all(2,:));
            
            leftdown_i = all(1,:);
            rightup_i = all(2,:);
            
            
            %check if indices exist in the volume, otherwise adapt
            leftdown_i(leftdown_i<1)=1;
            rightup_i(rightup_i>obj.volumeInfo.dimensions) = obj.volumeInfo.dimensions(rightup_i>obj.volumeInfo.dimensions);
            
            
            newVoxelArray = obj.voxelArray(...
                leftdown_i(1):rightup_i(1),...
                leftdown_i(2):rightup_i(2),...
                leftdown_i(3):rightup_i(3));
            
            croppedVolume = Volume;
            croppedVolume.volumeInfo = obj.volumeInfo;
            croppedVolume.voxelArray = newVoxelArray;
            croppedVolume.volumeInfo.id = [obj.volumeInfo.id,'_cropped_',strrep(strrep(strrep(datestr(datetime),'-',''),' ',''),':','')];
            croppedVolume.volumeInfo.dimensions = size(newVoxelArray);
            croppedVolume.volumeInfo.origin = SDK_transform3d(leftdown_i,inv(obj.gettransformtovoxelindices));
            
            
            
            
            
            
            
        end
        
        
        
    end
    
end


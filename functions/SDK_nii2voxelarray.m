
%this draft version requiers SPM to be added to the MATLAB-path.

%Load nifti file:
[fileName,filePath] = uigetfile('*.nii');
niiFile = spm_vol([filePath,fileName]);

%position of nifti file in 3D nifti-space:
volumeOrientation_nii = niiFile.mat
volumeDimensions = niiFile.dim;


%convert to SureTune/Dicom space (x and y axes are flipped)
volumeOrientation_dcm = [-1 0 0 0;0 -1 0 0; 0 0 1 0; 0 0 0 1]*volumeOrientation_nii;

%translate the volume to our atas space (MNI-STN-Left)
volumeOrientation_dcm = SDK_registerSTN(volumeOrientation_dcm);


%Get image data
voxelArray=spm_read_vols(niiFile);



%Save bin
[voxelArray_dcm,volumeDimensions] = SDK_GetAxial(voxelArray,volumeOrientation_dcm,volumeDimensions);


whiteValue = max(voxelArray_dcm(:));
rescaleSlope = whiteValue/65535;

[~,~,~] = mkdir(filePath,[fileName,'_SureTune']);
ExportBin(voxelArray_dcm,fullfile(filePath,[fileName,'_SureTune'],'VoxelArray.bin'),rescaleSlope);  

%Generate InputArguments XML file
XML = SDK_CreateXML(volumeOrientation_dcm,volumeDimensions, fileName, 1);
%Save xml
struct2xml(XML,fullfile(filePath,[fileName,'_SureTune'],'volume.xml'));


cd(filePath)

edit helpSDK ; return

% With this toolbox you can extract most data from your Session and
% use it for analysis. 

% You'll start with making a new empty instance of a the Session class:

S = Session 

% I usually name it 'S', but you can of course choose any name.

% The next step is to populate this instance with data. Most likely you
% have exported a Session from SureTune as a DICOM file. You can load this
% by using:

S.loadsession() % or S.loadsession('C:/yourdirectory/file.dcm')

% Your session-instance now contains all data and UI settings that were in
% SureTune.

S.sessionData % contains all raw xml data
S.volumeStorage % contains all imaging data
S.meshStorage % contains all 3D structures
S.therapyPlanStorage % contains therapy settings including VTAs

% The power of SureTune is that all volumes, meshes and therapyPlans are
% registered to each other. Everything that has a location is called a
% 'Registerable'. You can get an overview of all Registerables with:

S.listregisterables

% You can also get a specific registerable by:

myRegisterable = S.getregisterable;
% Or
myRegisterable = S.getregisterable(3); %if you know the index already

% There are various classes (as you can see in the folder:
% SureSuiteSDK/Classes)  each with its own functions/methods. You can explore the
% methods using 'methods [class]'  for example:

methods ManualStructureSegmentation




%% Example 1: Find the center of gravity of a mesh in ACPC space

% 1. instantiate empty session
S = Session;

%2. load dcm file
S.loadsession;

%3. get the manualSegmentation-registerable:
myManualSegmentation = S.getregisterable; %then select the appropriate index

%4. get the mesh from the manual segmentation:
myMesh = myManualSegmentation.getmesh;

%5. show the mesh with default settings:
figure;
myMesh.patch 

%or add any arguments for MATLABs patch function:
figure;
ObjectHandle = myMesh.patch('facecolor', rand(1,3), 'EdgeColor','none');
alpha(ObjectHandle, 0.7);

%6. get the center of gravity (cog) from the mesh with 0.1mm precision
cog_segmentationSpace = myMesh.computecenterofgravity(0.1);

%7. convert the coordinates to ACPC using the ACPC registerable (only works
%if annotated ACPC in SureTune)

acpcRegisterable = S.getregisterable; %select acpcCoordinateSytem
transformationMatrix = S.gettransformfromto(myManualSegmentation,acpcRegisterable);
cog_acpcSpace = SDK_transform3d(cog_segmentationSpace,transformationMatrix);


%% Example 2: Add 3D meshes to a session
% The structure we are going to make will look like this:
% Session
%  > ImportedStructure
%      > meshpart_1

% Where the meshpart points to a mesh that is present in MeshStorage.
% In theory we could add a lot more meshparts to one importedStructure. If
% we want to, all of the meshparts may even point to the same mesh in the
% meshStorage. 

% For example, we could make a cloud of spheres, by adding 10 meshparts to
% one ImportedStructure. All of the meshparts could point to the same file
% eg sphere.obj. But each meshpart will have a unique transformation
% matrix. to scale/move the sphere into position.




% 1. instantiate empty session
S = Session;

%2. load dcm file
S.loadsession;

%3. Define meshes

V = [-1,1,1;...
    1,1,1;...
    1,-1,1;...
    -1,-1,1;...
    -1,1,-1;...
    1,1,-1;...
    1,-1,-1;...
    -1,-1,-1];
F  = [1,2,4;...
    4,3,2;...
    3,7,2;...
    2,7,6;...
    7,8,6;...
    8,6,5;...
    1,4,8;...
    8,1,5;...
    1,2,5;...
    5,6,2;...
    4,3,8;...
    8,3,7];
    

%4. Select the parent Registerable to define the coordinate system:
parent = S.getregisterable();

%5. Set the transformation matrix 
transformationMatrix = eye(4);

%6.  - Make the importedstructure with opacity of 1
myImportedStructure = S.addmesh(V,F,'myCube',parent,T)

% or

myImportedStructure = S.addmesh(V,F,'myCubeRed',parent,T,'#FF0000')

















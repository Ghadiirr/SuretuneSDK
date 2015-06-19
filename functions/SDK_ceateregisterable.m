function [ R ] = SDK_CreateRegisterable( varargin )
%SDK_CREATEREGISTERABLE Summary of this function goes here
%   Detailed explanation goes here

obj = varargin{1};
path = varargin{2};
RegType = varargin{3};
id = varargin{4};
accepted = varargin{5};
parent = varargin{6};
T = varargin{7};



%Define component_args
component_args = {path,obj};
registerable_args = {parent,T,accepted,id};

% Every registerable types has its own class

switch RegType
    case 'Dataset'
        XML = eval(path);
        label = XML.label.Attributes.value;
        volumeId = XML.volumeId.Attributes.value;
        try
            Id = XML.Attributes.id;
        catch Id = 'Dataset2';
        end
        
        %Dataset may have a STF.
        if isfield(XML.stf,'Stf')
            stf = Stf(XML.stf.Stf.accepted.Attributes.value,XML.stf.Stf.transform,XML.stf.Stf.type.Enum.Attributes.value,XML.stf.Stf.localizerPoints);
        else
            stf = [];
        end
        
        
        
        R = Dataset(component_args,registerable_args,...
            label,volumeId,Id,stf);
    case 'Lead'
        XML = eval(path);
        
        label = XML.label.Attributes.value;
        leadType = XML.leadType.Enum.Attributes.value;
        distal = SDK_Point3D2vector(XML.distal.Point3D);
        proximal = SDK_Point3D2vector(XML.proximal.Point3D);
        stimPlans = XML.stimPlans.Array; %has to be improved
        
        R = Lead(component_args,registerable_args,distal,proximal,stimPlans,leadType,label);
        
        
    case 'ACPCIH'
        XML = eval(path);
        
        ac = SDK_Point3D2vector(XML.ac.Point3D);
        pc = SDK_Point3D2vector(XML.pc.Point3D);
        ih = SDK_Point3D2vector(XML.ih.Point3D);
        
        R = ACPCIH(component_args, registerable_args,ac,pc,ih);
        
    case 'ImageBasedStructureSegmentation'
        XML = eval(path);
        
        label = XML.label.Attributes.value;
        opacity = XML.opacity.Attributes.value;
        color = XML.color.Attributes.value;
        threshold = XML.threshold.Attributes.value;
        thresholdType = XML.thresholdType.Enum.Attributes.value;
        blurEnabled = XML.blurEnabled.Attributes.value;
        boundingBox.leftDown =SDK_Point3D2vector(XML.boundingBox.BoundingBox.leftDown.Point3D);
        boundingBox.rightUp =SDK_Point3D2vector(XML.boundingBox.BoundingBox.rightUp.Point3D);
        
        %optional fields;
        if isfield(XML.includeSeeds.Array,'Point3D')
            includeSeeds = SDK_Point3D2vector(XML.includeSeeds.Array.Point3D);
        else
            includeSeeds = [];
        end
        
        if isfield(XML.excludeSeeds.Array,'Point3D')
            excludeSeeds = SDK_Point3D2vector(XML.excludeSeeds.Array.Point3D);
        else
            excludeSeeds = [];
        end
        
        R = ImageBasedStructureSegmentation (component_args,registerable_args,label, opacity, color, threshold, thresholdType, blurEnabled,boundingBox, includeSeeds, excludeSeeds);
        
        
    case 'Path'
        XML = eval(path);
        
        label = XML.label.Attributes.value;
        target = SDK_Point3D2vector(XML.target.Point3D) ;
        entry = SDK_Point3D2vector(XML.entry.Point3D) ;
        opacity = XML.opacity.Attributes.value;
        marginRadius = XML.marginRadius.Attributes.value;
        beyondTargetDistance = XML.beyondTargetDistance.Attributes.value;
        
        R = Path(component_args, registerable_args,label,target,entry,opacity,marginRadius,beyondTargetDistance);
        
        
    case 'ManualStructureSegmentation'
        XML = eval(path);
        
        opacity = XML.opacity.Attributes.value;
        color = XML.color.Attributes.value;
        contourStacks = XML.contourStacks.HashTable.ContourStack;
        label = XML.label.Attributes.value;
        
        R = ManualStructureSegmentation(component_args, registerable_args,label,opacity,color,contourStacks);
        
    case 'ImportedStructure'
        XML = eval(path);
        
        try label = XML.label.Attributes.value;
        catch
            warning('No label was found for the imported Structure')
            label='nolabel';
        end
        opacity = XML.opacity.Attributes.value;
        
        R = ImportedStructure(component_args, registerable_args,label,opacity);
        
        
    case 'ImportedMeshPart'
        XML = eval(path);
        
        meshId = XML.meshId.Attributes.value;
        color = XML.color.Color.Attributes.value;
        opacity = XML.opacity.Attributes.value;
        
        R = ImportedMeshPart(component_args, registerable_args,meshId,color,opacity);
        R = []; %don't add all meshParts to the registerable list.
        
        
    otherwise
        warning(['Class ',RegType,' not defined.'])
        R = [];
        
        
        
        
        
        
        
end










end


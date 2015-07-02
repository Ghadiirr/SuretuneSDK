classdef ImportedStructure < SessionComponent & Registerable
    %LEAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        opacity
        parts = {};
    end
    
    methods
        function obj = ImportedStructure(component_args, registerable_args,label,opacity)
            
            %inherit superclass properties from SessionComponent and
            %Registerable classes.
            obj@SessionComponent(component_args{:});
            obj@Registerable(registerable_args);
            
            obj.label = label;
            obj.opacity = opacity;
            
            
        end
        
        
        
        function obj = addparts(obj,parts)
            if iscell(parts)
                for i = numel(parts)
                    
                    %update parent
                    
                    obj.parts{end+1} = parts{i};
                end
            else
                parts.parent = obj;
                obj.parts{end+1} = parts;
            end
        end
        
        
        
        function obj = set.label(obj,label)
                      
          
            %change object
            obj.label = label;
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.label.Attributes.value',label,'label');
            
        end
        
                
        function obj = set.opacity(obj,opacity)

            %change object
            obj.opacity = opacity;
            
            
            %update the XML;
            SDK_updatexml(obj.session,obj,'.opacity.Attributes.value',opacity,'Opacity');
            
        end
        
        
        function obj = addnewpart(varargin)
            
            if nargin == 1
                disp('input arguments should be: [object],label,color,opacity,T,MeshId')
                return
            end
            obj = varargin{1};
            label = varargin{2};
            color = varargin{3};
            opacity = varargin{4};
            T = varargin{5};
            meshId = varargin{6};
            
          
          %Determine XML path
          genericPath = [obj.path,'.parts.Array.ImportedMeshPart'];
          genericPath = strrep(genericPath,'obj','rootsession');
          rootsession = obj.session;
          
          index = numel(eval(genericPath)) +1;
          thispath = [genericPath,'{',num2str(index),'}'];
          
          
          thispath2 = strrep(thispath,'rootsession','obj');
          component_args = {thispath2,rootsession};
          registerable_args = {obj,T,0,label}; %set accepted to false
          
          %Make dummy elements in XML
          
          A.Parent.ref.Text = '';
            A.Parent.ref.Attributes.id = obj.matlabId;
            A.Transform.Matrix3D.Text = '';
                        A.meshId.Text = '';
            A.MeshId.Attributes.type = 'String';
%             A.meshId.Attributes.value = 'Dummytxt'; %filename.obj
%                         A.color.Color.Attributes.value = '#999999';
            A.Color.Color.Text = '';
            A.Opacity.Text = '';
            
            A.Opacity.Attributes.type = 'Double';
            A.Accepted.Attributes.type = 'Bool';
            
            A.AmbientLightingLevel.Attributes.type = 'Double';
            A.DiffuseLightingLevel.Attributes.type = 'Double';
            A.SpecularLightingLevel.Attributes.type = 'Double';




            
            %add dummy elements
            eval([thispath,' = A;']);
            
            obj = ImportedMeshPart(component_args, registerable_args,meshId,color,opacity);

            
            
            
            

          
          
          
          
            
            
            
            
        end
            
            
        
    end
    
end


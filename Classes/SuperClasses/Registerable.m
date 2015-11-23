classdef (Abstract) Registerable < handle
    %REGISTERABLE Summary goes here
    %   Details go here
    
    properties
        accepted
        parent
        transform
        matlabId  %not sure if this one will be needed.
    end
    
    properties (Hidden = true)
%         trackChanges
    end
    
    methods
        
        function obj = Registerable(argin)
            
            if nargin==0
                error('Registerables can only be made within a Session.')
            end
            
            if nargin==1
                if isa(argin,'Registerable');
                    %a registerable is used to instantiate a registerable
                    %superclass
                    inputRegisterable = argin;
                    parent = inputRegisterable.parent;
                    transform = inputRegisterable.transform;
                    matlabId = inputRegisterable.MATLABName;
                    accepted = inputRegisterable.accepted;
                elseif isa(argin,'cell')
                    inputCell = argin;
                    parent = inputCell{1};
                    transform = inputCell{2};
                    accepted = inputCell{3};
                    matlabId = inputCell{4};
                end
            end
            
            
            %             obj.path = path;
            %             obj.id = id;
            %             obj.label = label;
            
            % Initialize all registerables with trackChanges turned off. If
            % the registerable constructed trackChanges can be turned on.
            % This prevents echoing the original data.
%             S.updateXml = 0;  
            obj.matlabId = matlabId;
            obj.accepted = accepted;
            obj.parent = parent;
            obj.transform = transform;
            

            %             obj.session = instance;
        end
        
        
        
    end
    
    
    methods  %Set methods
        
        
        function obj = set.accepted(obj,accepted)
            
            S = obj.session;
              if ~S.updateXml;obj.accepted=accepted;return;end
            
            switch class(accepted)
                case 'logical'
                    if istrue(accepted)
                        newval = 'True';
                    else
                        newval = 'False';
                    end
                case 'char'
                    switch lower(accepted)
                        case 'true'
                            newval = 'True';
                        case 'false'
                            newval = 'False';
                    end
                case 'double'
                    if accepted==1
                        newval = 'True';
                    else
                        newval = 'False';
                    end
            end
            if not(exist('newval'))
                error('Argument has to be either true or false')
            end
            
            oldval = obj.accepted;
            
            
            %change the value in the object
            obj.accepted = newval;
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            if S.updateXml;
                SDK_updatexml(S,obj,'.accepted.Attributes.value',newval,'accepted state');
            end
            

            
            
        end
        
        function obj = set.parent(obj,newParent)
            
            %check if parent is a SessionComponent (Lead/Dataset/..) or a string.
            % if string:
            %  does it match with a registerable?
            
            S = obj.session;
%             if ~S.updateXml;obj.parent=newParent;return;end
            
            
            if ischar(newParent);
                %get the list of all current registerables
                allparents = eval('obj.session.listregisterables');
                if not(any(ismember(allparents,newParent)));  %if it is a session component
                    if S.updateXml;
                        warning('Parent is not known. Changes are still applied');
                    end
                    parentobj = newParent; %use string instead
                else
                    parentobj = eval(['obj.session.getregisterable(''',newParent,''')']);
                end
            else
                try
                    supercl = superclasses(newParent);
                    if any(ismember(supercl,'SessionComponent'));  %if it is a session component
                        parentobj = newParent;
                        newParent = newParent.matlabId;
                        
                    end
                catch error('Parent should be char or a Registerable')
                end
            end
            
            %change the value in the object
            obj.parent = parentobj;
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log

            if S.updateXml;
                SDK_updatexml(S,obj,'.parent.ref.Attributes.id',newParent,'Parent');
            end

           
            
        end
        
        function obj = set.transform(obj,transform)
            
            S = obj.session;
              if ~S.updateXml;obj.transform=transform;return;end
            
            if ismatrix(transform) && numel(transform)==16
                Tarray = reshape(transform,[1,16]);
            else
                error('T has to be a 4x4 matrix')
            end
            
                        
            if all(transform(1:3,4) == [0;0;0]) && any(not(transform(4,1:3)==[0,0,0]))
                %                 disp('[transposed transformation matrix]')
                obj.session.addtolog('[transposed transformation matrix]')
                transform = transform';
                Tarray = reshape(transform,[1,16]);
            end
            
            
            %change the value in the object
            obj.transform = transform;
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            
            XML_names = {'m11','m12','m13','m14','m21','m22','m23','m24','m31','m32','m33','m34','ox','oy','oz','m44'};
        
            
            
            if S.updateXml
                for i = 1:16
                    SDK_updatexml(S,obj,['.transform.Matrix3D.Attributes.',XML_names{i}],Tarray(i),XML_names{i});
                end
            end
            
            
        end
        
        
    end
    
end
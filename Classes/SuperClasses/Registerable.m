classdef (Abstract) Registerable < handle
    %REGISTERABLE Summary goes here
    %   Details go here
    
    properties
        accepted
        parent
        T
        matlabId  %not sure if this one will be needed.
    end
    
    properties (Hidden = true)
        noSet
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
                    T = inputRegisterable.T;
                    matlabId = inputRegisterable.MATLABName;
                    accepted = inputRegisterable.accepted;
                elseif isa(argin,'cell')
                    inputCell = argin;
                    parent = inputCell{1};
                    T = inputCell{2};
                    accepted = inputCell{3};
                    matlabId = inputCell{4};
                end
            end
            
            
            %             obj.path = path;
            %             obj.id = id;
            %             obj.label = label;
            obj.noSet = 1;
            obj.accepted = accepted;
            obj.parent = parent;
            obj.T = T;
            obj.matlabId = matlabId;
            obj.noSet = 0;
            %             obj.session = instance;
        end
        
        
        
    end
    
    
    methods  %Set methods
        
        
        function obj = set.accepted(obj,accepted)
            
            S = obj.session;
            if S.noLog;obj.accepted=accepted;return;end
            
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
            
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            if ~obj.noSet;
                S.log('Changed accepted state from %s to %s for %s',oldval,newval, obj.matlabId);
            end
            
            %change the value in the object
            obj.accepted = newval;
            
            %update the XML
            SDK_updateXML(S,obj,'.accepted.Attributes.value',newval);
        end
        
        function obj = set.parent(obj,newparent)
            
            %check if parent is a SessionComponent (Lead/Dataset/..) or a string.
            % if string:
            %  does it match with a registerable?
            
            S = obj.session;
            if S.noLog;obj.parent=newparent;return;end
            
            
            if ischar(newparent);
                %get the list of all current registerables
                allparents = eval('obj.session.getRegs');
                if not(any(ismember(allparents,newparent)));  %if it is a session component
                    warning('Parent is not known. Changes are still applied')
                    parentobj = newparent; %use string instead
                else
                    parentobj = eval(['obj.session.getReg(''',newparent,''')']);
                end
            else
                try
                    supercl = superclasses(newparent);
                    if any(ismember(supercl,'SessionComponent'));  %if it is a session component
                        parentobj = newparent;
                        newparent = newparent.matlabId;
                        
                    end
                catch error('Parent should be char or a Registerable')
                end
            end
            
            
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            if ~obj.noSet;
                S.log('Changed parent from %s to %s for %s',obj.parent.matlabId,newparent, obj.matlabId);
            end
            %change the value in the object
            obj.parent = parentobj;
            
            %update the XML
            SDK_updateXML(S,obj,'.parent.ref.Attributes.id',newparent);
        end
        
        function obj = set.T(obj,T)
            
            S = obj.session;
            if S.noLog;obj.T=T;return;end
            
            if ismatrix(T) && numel(T)==16
                Tarray = reshape(T,[1,16]);
            else
                error('T has to be a 4x4 matrix')
            end
            
            
            %write it in the log.
            %-- get the Session.
            S = obj.session;
            %--update its log
            
            
            %change the value in the object
            obj.T = T;
            
            
            XML_names = {'m11','m12','m13','m14','m21','m22','m23','m24','m31','m32','m33','m34','ox','oy','oz','m44'};
            
            for i = 1:16
                SDK_updateXML(S,obj,['.transform.Matrix3D.Attributes.',XML_names{i}],Tarray(i));
            end
            
            if obj.noSet;obj.T = T;return;end
            S.log('Changed registration matrix for %s',obj.matlabId);
            
            
        end
        
        
    end
    
end
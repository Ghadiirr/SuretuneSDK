function [R ] = SDK_findregistrables( obj )
%SDK_FINDREGISTRABLES Summary of this function goes here
%   Detailed explanation goes here


%% Run through the tree to find registerables

P = {'current','path','of','cells','and','structures',...
    0, 0, 0, 1, 0, 0};

%init
P = {};
C = {};
level = 0;
unfinished_cell = {};

Regs = {};
fprintf('\nFinding Registrables: 000')

%the following while loop browses through all elements of the structure,
%and nested structures.
%--Checks
%   Is the current element a registerable?
%   Is the current element array? --> make the child a cell.
%--Find children
%   There are four options:
%   O the current element is a structure
%   O the current element is a cell
%   O the current element is the root element
%   O the current element has no children
%--Select a child
%-Repeat


while level >=0
    
    if level>1
        Regs = SDK_manageregistrables(obj,Regs,P,level);
        
        if strcmp(P{level},'Array');
            Plevel = {P{1:level}};
            evalstr = ['obj.',strjoin(Plevel,'.')];
            current = eval(evalstr);
            if isstruct(current)
                child = fieldnames(current);

                if ~iscell(current.(child{1})) && ~strcmp(child,'Text') %if the the child is not a cell and not 'Text'
                    eval([evalstr,'.',child{1},' = {current.(child{1})};']);
                end
            end
        end
                
            
            
    end
    
   
    
    
    %erase P history
    P(level+2:end) = [];
    
    %define current position in structure
    if level>0
        Plevel = {P{1:level}};
        evalstr = ['obj.',strjoin(Plevel,'.')];
        
        %if current position is no long SessionData >> abort
        if strcmp(P{level},'therapyPlanStorage');break;end
        if strcmp(P{level},'volumeStorage');break;end
        if strcmp(P{level},'meshStorage');break;end
    else
        evalstr = 'obj';
    end
    debug(['Currently: ',evalstr])
    
    
    %find children
    cellflag = 0;
    switch class(eval(evalstr))
        case 'struct'
            children = fieldnames(eval(evalstr));
        case 'cell'
            numchildren = numel(eval(evalstr));
            
            
            % thise lines construct a cell array that looks like:
            % {'thiscell{1}','thiscell{2}'}
            childstr = sprintf(['''',P{level},'{%d}'','],1:numchildren);
            children = eval(['{',childstr(1:end-1),'}']);   %end-1 in order to cut-off the last comma.
            level = level-1;  %the next child is reached by replacing the thisisacell with thisisacell{index}. In order to change the name we have to step back one level first.
            
            cellflag = 1;
            
        case 'Session'  %we are back at the root.
            children = fieldnames(eval(evalstr));
        otherwise %dead end, no children.
            
            %check if the current level contains cell indexing.
            bracket_index = find(P{level}=='{');
            if not(isempty(bracket_index))  %if any character is {
                thisPlevel = P{level};
                P{level} = thisPlevel(1:bracket_index-1); %remove indexing
                debug('dead end on cell, remove indexing')
                continue
            end
            
            level = level -1;
            debug('dead end, go back one level.')
            continue % no children, so go back
    end
    
    
    
    %-----------------------------------------
    % if the loop passes this line, it means the current node has children.
    
    
    %Advance one level
    level = level+1;
    
    %Pick a child
    if numel(P) >= level %if we have been this deep
        
        if cellflag % if we are at a cell
            if numel(C) >= level  %if we have ever encountered a cell this deep
                
                if isempty(C{level}) %first time on this particular cell
                    C{level} = 1;   %set cell indexing to 1.
                    P{level} = children{1}; %select the first cell in the list.
                    
                elseif C{level} ==0
                    C{level} = 1;
                    P{level} = children{1};
                else %we have been here before
                    %better erase all names after this cell, since they may
                    %be similar
                    P(level+1:end) = [];
                    
                    if C{level}==numel(children) %if we are in the last cell element
                        level = level-1;
                        goback = 1;
                        C{level+1} = [];
                        debug('last cell element. Erase cell counter. Step back one level')
                        continue
                        
                    else % if there are more children
                        C{level} = C{level}+1;  %index +1
                        P{level} = children{C{level}};  %select the next cell element
                        
                    end
                end
            else  %never been here, so we don't need checks. Just take the first element.
                C{level} = 1;
                P{level} = children{1};
            end
            
            
            
            continue
        end
        
        
        %------------------
        %If the loop gets here, the current node is a structure element.
        
        %Find if the path history, is one of the children you have to
        %choose from.
        
        ind = find(ismember(children,P{level}));
        if isempty(ind) %if no match, start at first.
            
            
            
            P{level} = children{1};
            
            
        else
            if numel(children) > ind %if the current match is not the last one in the list
                P{level} = children{ind+1};
            else %we are at the last one of the list.
                
                %if we are back the root, it means we have seen everything.
                if level==1
                    level=-1;
                    debug('done.')
                    continue
                end
                
                %check if the current level contains cell indexing.
                bracket_index = find(P{level-1}=='{');
                if not(isempty(bracket_index))  %if any character is {
                    thisPlevel = P{level-1};
                    P{level-1} = thisPlevel(1:bracket_index-1); %remove indexing
                    debug('fully explored cell element, remove indexing')
                    level = level-1;
                    continue
                end
                
                
                
                level = level-2;
                continue
            end
            
        end
    else %first time
        P{level} = children{1};
        if cellflag
            C{level} = 1;
        end
        
        %check if the new child is a cell, if so make sure to finish it.
        Plevel = {P{1:level}};
        newchild = eval(['obj.',strjoin(Plevel,'.')]);
        if iscell(newchild)
            
            unfinished_cell{end+1} = P{level};
        end
    end
end



%% all registerables have been found. Now make objects

%initiate with MASTER

%Find index of master
index = find(ismember({Regs{5,:}},'ROOT'));

R.names{1} = Regs{3,index}; %Add the first element to the namelist;
R.list{1} = SDK_createregisterable(obj,Regs{:,index}); %Pass properties to build first registerable;


%While-loop until nothing changes to add dependencies
nochanges = 0;
index = 0;
while nochanges < size(Regs,2)
    if index == size(Regs,2);index = 0; end %keep index within limits
    nochanges = nochanges+1;
    index = index+1;
    
    %get current name
    thisName = Regs{3,index};
    
    
    %Check if current name is unique
    nameindex = find(ismember(R.names,thisName));
    
    if isempty(nameindex) %unique
        
        %check if parent already exists
        if ~ischar(Regs{5,index}) %if it is not a char, it must have been replaced with its parent already.
            continue
        end
        
        parentName = strrep(Regs{5,index},' ','');
        parentindex = find(ismember(R.names,parentName));
        
        if isempty(parentindex)%parent does not exist
            continue
        else %parent does exist
            nochanges = 0;
            
            %replace parent with its object
            parent = R.list{parentindex};
            Regs{5,index} = parent;
            
            %get element number
            elnr = numel(R.names)+1;
            
            
            %make registerable object
            registerable = SDK_createregisterable(obj,Regs{:,index});
            
            if ~isempty(registerable)
                R.list{elnr} = registerable;
                R.names{elnr} = thisName;
            end
                
            
        end
        
        
        
    else
        continue
    end
    
    
    
end




fprintf('\n')
end



function debug(string)
if false    %set to true for debugging
    disp(string)
end
end

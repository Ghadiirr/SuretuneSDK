function [ handles ] = SDK_showboundingboxes( obj )
%SDK_SHOWBOUNDINGBOXES Summary of this function goes here
%   Detailed explanation goes here

figure;
[allRegNames,allRegTypes] = obj.listregisterables;
colormap(lines);
cmap = colormap;
legendnames = {};
handles = {};

for iReg = 1:numel(allRegNames)
    iReg
    switch allRegTypes{iReg}
        case 'Dataset'
            cubeGeometry = [1,1,1;...
                1,1,2;...
                1,2,1;...
                1,2,2;...
                2,1,1;...
                2,1,2;...
                2,2,1;...
                2,2,2];
            thisReg = obj.getregisterable(allRegNames{iReg});
            
            thisTransform = obj.gettransformroot(thisReg);
            thisBoundingBox = thisReg.volume.getboundingbox';
            
                        % construct vertices
            vertices = zeros(8,3);
            for i  = 1:size(cubeGeometry,1)
                vertices(i,1) = thisBoundingBox(cubeGeometry(i,1),1);
                vertices(i,2) = thisBoundingBox(cubeGeometry(i,2),2);
                vertices(i,3) = thisBoundingBox(cubeGeometry(i,3),3);
            end
            
            vertices = SDK_transform3d(vertices,thisTransform);
            

            
            %construct faces
            faces = convhull(vertices);
            
            %patch
            
            h = patch('Vertices', vertices, 'Faces', faces,'FaceColor',cmap(iReg,:),'EdgeColor','none');
            alpha(0.2)
            hold on
            
            legendnames{end+1} = thisReg.label;
            handles{end+1} = h;
            
            
        case 'Lead'
            thisReg = obj.getregisterable(allRegNames{iReg});
            thisTransform = obj.gettransformroot(thisReg);
            
            distal = SDK_transform3d([0,0,0],thisTransform);
            proximal = SDK_transform3d([0,0,100],thisTransform);

            
            %Their vertial concatenation is what you want
            pts = [distal; proximal];
            
            %Because that's what line() wants to see
            h = line(pts(:,1), pts(:,2), pts(:,3),'LineWidth',2,'Color',cmap(iReg,:))
            legendnames{end+1} = thisReg.label;
            handles{end+1} = h;
            
%             Alternatively, you could use plot3:
%             plot3(pts(:,1), pts(:,2), pts(:,3))
            
            
            
        case 'ACPCIH'
            thisReg = obj.getregisterable(allRegNames{iReg});
            AC = thisReg.ac;
            PC = thisReg.pc;
            IH = thisReg.ih;
            
            line1 = [AC; PC];
            line2 = [mean(line1);IH];
            h1 = line(line1(:,1), line1(:,2), line1(:,3),'LineWidth',2,'Color',cmap(iReg,:));
            h2 = line(line2(:,1), line2(:,2), line2(:,3),'LineWidth',2,'Color',cmap(iReg,:));
            legendnames{end+1} = 'ACPC';
            
            handles{end+1} = [h1,h2];
            
            
            
            
            
            
        otherwise
            continue
    end
    
    
    
end


set(gcf, 'renderer', 'opengl')
view(3); axis equal;
camlight
legend(legendnames{:})
end


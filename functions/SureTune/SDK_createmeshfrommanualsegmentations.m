function [ mesh ] = SDK_createmeshfrommanualsegmentations( manualSegmentation )
%SDK_CREATEMESHFROMCONTOURS Summary of this function goes here
%   Detailed explanation goes here

edgelength  = 2;

contours = manualSegmentation.getallcontours;
%Resample at 1.0mm intervals to have uniform distribution of control
%points:
resampledContours = {};
for iContour  = 1:numel(contours);
    PolyLine = SDK_updatepolylinesegments(contours{iContour});
    linesegments = SDK_resamplelinesegments(PolyLine,edgelength);
    resampledContours{iContour} = vertcat(linesegments{:});
end

% All points are equal, so convert contours to a point cloud:
points = vertcat(resampledContours{:});

%Calculate convex hull
% mesh = Obj(points,convhull(points),'temp');

%calculate concave hull
concavefaces = concavetest(points,convhull(points));
% mesh = Obj(points,concavefaces,'temp');
% figure;
% mesh.patch

% 
% face_output = swapedges(points,concavefaces,0.5);
mesh = Obj(points,concavefaces,'temp');


figure;
mesh.patch

% % mesh.simultaneoussubdividesurface(edgelength,2000,0.75);
% mesh.simultaneoussubdividesurface_angle(0.1,2000,0.75)
% % figure;
% figure;
% mesh.patch
% axis off


end

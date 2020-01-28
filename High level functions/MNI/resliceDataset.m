function [ Iwarp, Rto ] = resliceDataset( from, to, T )
%RESLICEDATASET Summary of this function goes here
%   Detailed explanation goes here

a = 1;
b = 2;
c = 3;

conversion = eye(4);%diag([-1 -1 1 1]);

reshapeorder = [1 2 3];

switch class(from)
    case 'Volume'
    f = from.volumeInfo;
    Ifrom = permute(from.voxelArray,[2 1 3]);
    case 'Dataset'
    f = from.volume.volumeInfo;
    Ifrom = permute(from.volume.voxelArray,[2 1 3]);
end

Rfrom = imref3d(f.dimensions([2 1 3]),f.spacing(a),f.spacing(b),f.spacing(c));
    Rfrom.XWorldLimits = Rfrom.XWorldLimits+f.origin(a)-f.spacing(a);%-Rfrom.ImageExtentInWorldX;
    Rfrom.YWorldLimits = Rfrom.YWorldLimits+f.origin(b)-f.spacing(b);%-Rfrom.ImageExtentInWorldY;
    Rfrom.ZWorldLimits = Rfrom.ZWorldLimits+f.origin(c)-f.spacing(c);%-Rfrom.ImageExtentInWorldZ;


%Tfromto
if nargin==3
    Tfromto = affine3d(round(T,10));
else
    Tfromto = affine3d(conversion*round(from.session.gettransformfromto(from,to),10));
end
%Rto
t = to.volume.volumeInfo;
Rto = imref3d(t.dimensions([2 1 3]),t.spacing(a),t.spacing(b),t.spacing(c));
    Rto.XWorldLimits = Rto.XWorldLimits+t.origin(a)-t.spacing(a);%-Rto.ImageExtentInWorldX;
    Rto.YWorldLimits = Rto.YWorldLimits+t.origin(b)-t.spacing(b);%-Rto.ImageExtentInWorldY;
    Rto.ZWorldLimits = Rto.ZWorldLimits+t.origin(c)-t.spacing(c);%-Rto.ImageExtentInWorldZ;
%Ito
%Ito = permute(to.volume.voxelArray,[2 1 3]);

    try
    [Iwarp,Rwarp] = imwarp(Ifrom,Rfrom,Tfromto,'OutputView',Rto,'FillValues',min(Ifrom(:)));
    catch
        disp('?')
    end
    %convert Iwarp back to [xyx]
    
    Iwarp = permute(Iwarp,[2,1,3]);
    
% whatis(Iwarp)
%     i = floor(size(Ito,3)/2);
%     
%     [Islicew,Rslicew] = getslice(Iwarp,Rwarp,'axial',i)   ; 
%     [Islicet,Rslicet] = getslice(Ito,Rto,'axial',i)    ;
%     
% %     Islicet(Islicet>prctile(Islicet(:),95)) = prctile(Islicet(:),95);
% %     figure;imshow(Islicet/prctile(Islicet(:),95),Rslicet)
% 
%     
%     figure;
%     imshowpair(Islicet,Rslicet,Islicew,Rslicet)
% 

%     
end


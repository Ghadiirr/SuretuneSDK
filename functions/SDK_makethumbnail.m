function [ output_args ] = SDK_makeThumbnail( input_args )
%SDK_MAKETHUMBNAIL Summary of this function goes here
%   Detailed explanation goes here


im = load('thumbnail.mat');
im = im.thumbnail;
hf = figure('color','white','units','normalized','position',[.1 .1 .8 .8]);
image(im)
% Text at arbitrary position
t = text('units','pixels','position',[256 100],'fontsize',30,'color',[1 1 1],'string','hier komt wat tekst');

t.HorizontalAlignment = 'left';

% Capture the text image
% Note that the size will have changed by about 1 pixel
tim = getframe(gca);
close(hf)
% Extract the cdata
tim2 = tim.cdata;
% Make a mask with the negative of the text
tmask = tim2==0;
% Place white text
% Replace mask pixels with UINT8 max
im(tmask) = uint8(255);
image(im);
axis off
imshow(thumbnail)



end


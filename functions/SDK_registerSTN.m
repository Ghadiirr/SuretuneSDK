function [ T ] = SDK_registerSTN( T )
%SDK_REGISTERSTN Summary of this function goes here
%   Detailed explanation goes here

this_is_MNI152 = 0;

if this_is_MNI152
%This method is based on our LEFT MNI-STN atlas.

%Our T2 atlas was manually registered to the MNI atlas.
%The transformation was extracted with session manager:

  STN2MNI = [0.99999683574458054, -0.00236482165819203, 0.00085797398049015927, 193.1885202826688;...
      0.0021929666312393292, 0.98657338986775756, 0.16330381900677116, 238.71689090917653;...
      -0.0012326387064031247, -0.1633014207634671, 0.98657545407254732, -6.614628532350304;...
      0,0,0,1];
  
%The inverse is needed to get to our atlas space:  
  MNI2STN = inv(STN2MNI);
  
%since rotation is minimal, I skip it (for now), since resampling will be very slow.
%Rotation should be possible with the new import/export function.

  T(1:3,4) = T(1:3,4)+MNI2STN(1:3,4);
  
  
  %Was not very good. So a little improvement:

%   offset = [1.2735894530881102 ; -23.671600338019957 ; 42.884914664622883];
offset = [0; 0;30];
  
  T(1:3,4) = T(1:3,4)+offset;
else
    
  
  Translation = [-96.719;-103.1351;-77.62];
  T(1:3,4) = Translation;
  
end





end


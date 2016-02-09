function [V,F] = SDK_obj2fv(filename)
  % Downloaded function from: http://www.alecjacobson.com/weblog/?p=917
  % Reads a .obj mesh file and outputs the vertex and face list
  % assumes a 3D triangle mesh and ignores everything but:
  % v x y z and f i j k lines
  % Input:
  %  filename  string of obj file's path
  %
  % Output:
  %  V  number of vertices x 3 array of vertex positions
  %  F  number of faces x 3 array of face indices
  %
  % Modified by M.A.J. Lourens on 24-09-2015
  
  fid = fopen(filename,'rt');
  % Check the number of lines in file
  nlines=sum( fread(fid,inf,'*uchar')==10);
  frewind(fid)
  V = zeros(nlines,3);
  F = zeros(nlines,3);
  vertex_index = 1;
  face_index = 1;
  line = fgets(fid);
  while ischar(line)
    vertex = sscanf(line,'v %f %f %f');
    face = sscanf(line,'f %d %d %d');
    face_long = sscanf(line,'f %d//%d %d//%d %d//%d',6);
    face_long_long = sscanf(line,'f %d/%d/%d %d/%d/%d %d/%d/%d',9);

    % see if line is vertex command if so add to vertices
    if(size(vertex)>0)
      V(vertex_index,:) = vertex;
      vertex_index = vertex_index+1;
   % see if line is simple face command if so add to faces
    elseif(size(face,1)==3)
      F(face_index,:) = face;
      face_index = face_index+1;
    % see if line is a face with normal indices command if so add to faces
    elseif(size(face_long,1)==6)
      % remove normal
      face_long = face_long(1:2:end);
      F(face_index,:) = face_long;
      face_index = face_index+1;
    % see if line is a face with normal and texture indices command if so add to faces
    elseif(size(face_long_long,1)==9)
      % remove normal and texture indices
      face_long_long = face_long_long(1:3:end);
      F(face_index,:) = face_long_long;
      face_index = face_index+1;
    else
%       fprintf('Ignored: %s',line);  %silenced by Jonas Roothans
    end

    line = fgets(fid);
  end
  V(vertex_index:end,:) = [];
  F(face_index:end,:) = [];
  fclose(fid);
end
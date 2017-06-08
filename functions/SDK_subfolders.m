function [ nameFolds ] = SDK_subfolders (folder )
%SDK_GETSUBFOLDER Summary of this function goes here
%   Detailed explanation goes here
            
            if nargin ==0 || strcmp(folder,'');
                d = dir();
            else
                d = dir(folder);
            end

            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds(ismember(nameFolds,{'.','..'})) = [];


end


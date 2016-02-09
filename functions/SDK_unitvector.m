function [ outVector ] = SDK_unitvector( inVector )
%SDK_UNITVECTYOR Summary of this function goes here
%   Detailed explanation goes here

outVector = zeros(size(inVector));

for i = 1:size(inVector,1)
    outVector(i,:) = inVector(i,:)./norm(inVector(i,:));
    
end

end


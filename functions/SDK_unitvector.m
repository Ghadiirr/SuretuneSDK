function [ outVector ] = SDK_unitvector( inVector )
%SDK_UNITVECTYOR Summary of this function goes here
%   Detailed explanation goes here


outVector = inVector./norm(inVector);

end


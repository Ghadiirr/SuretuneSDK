function [] = SDK_changepatientid( S,name )
%SDK_CHANGEPATIENTNAME Summary of this function goes here
%   Detailed explanation goes here

S.patient.patientID = name;

if isstruct(S.volumeStorage);
    for i = 1:numel(S.volumeStorage.list)
        thisV = S.volumeStorage.list{i};
        
        thisV.volumeInfo.patientId = name;

    end
end


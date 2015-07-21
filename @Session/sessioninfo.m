function sessioninfo(obj)
sessionname = obj.sessionData.SureTune2Sessions.Session.id.Attributes.value;
patientname = obj.sessionData.SureTune2Sessions.Session.patient.Patient.name.Attributes.value;
dateofbirth = obj.sessionData.SureTune2Sessions.Session.patient.Patient.dateOfBirth.Attributes.value;
gender = obj.sessionData.SureTune2Sessions.Session.patient.Patient.gender.Enum.Attributes.value;
savedate = obj.sessionData.SureTune2Sessions.Attributes.exportDate;

fprintf('Session info\n-----------------\n')
fprintf('%15s: %s\n','Session name',sessionname)
fprintf('%15s: %s\n','Export date',savedate)
fprintf('%15s: %s\n','Patient name',patientname)
fprintf('%15s: %s\n','Date of birth',dateofbirth)
fprintf('%15s: %s\n','Gender',gender)

end

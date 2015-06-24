function  [template] = SDK_createxml(volumeOrientation, dimensions, fileName, rescaleSlope)
%Since the correct folder was added to the path in a previous step, the
%inputarguments can be loaded right away:



template = XML2struct('xml_template.xml');



template.VolumeInfo.Dimension.X.Text = dimensions(1);
template.VolumeInfo.Dimension.Y.Text = dimensions(2);
template.VolumeInfo.Dimension.Z.Text = dimensions(3);

template.VolumeInfo.Origin.a_colon__x.Text = volumeOrientation(1,4);
template.VolumeInfo.Origin.a_colon__y.Text = volumeOrientation(2,4);
template.VolumeInfo.Origin.a_colon__z.Text = volumeOrientation(3,4);

template.VolumeInfo.Spacing.X.Text = norm(volumeOrientation(:,1));
template.VolumeInfo.Spacing.Y.Text = norm(volumeOrientation(:,2));
template.VolumeInfo.Spacing.Z.Text = norm(volumeOrientation(:,3));

% template.VolumeInfo.PatientOrientationX.a_colon__x = volumeOrientation(1,1)/norm(volumeOrientation(:,1));
% template.VolumeInfo.PatientOrientationX.a_colon__y = volumeOrientation(2,1)/norm(volumeOrientation(:,1));
% template.VolumeInfo.PatientOrientationX.a_colon__z = volumeOrientation(3,1)/norm(volumeOrientation(:,1));
% 
% template.VolumeInfo.PatientOrientationY.a_colon__x = volumeOrientation(1,2)/norm(volumeOrientation(:,2));
% template.VolumeInfo.PatientOrientationY.a_colon__y = volumeOrientation(2,2)/norm(volumeOrientation(:,2));
% template.VolumeInfo.PatientOrientationY.a_colon__z = volumeOrientation(3,2)/norm(volumeOrientation(:,2));

template.VolumeInfo.RescaleIntercept.Text = 0;
template.VolumeInfo.RescaleSlope.Text = rescaleSlope;

template.VolumeInfo.VolumeIdentifier.Text = ['FuncAtlas_',fileName];

end


% c = contourStacks
v = [];
for i = 1:numel(c.kv)
    try
    for j = 1:numel(c.kv{i}.ContourStack.slicesToContours.HashTable.kv)

        try
        for k = 1:numel(c.kv{i}.ContourStack.slicesToContours.HashTable.kv{j}.Array.Point3D)
            
            v(end+1,:) = SDK_point3d2vector(c.kv{i}.ContourStack.slicesToContours.HashTable.kv{j}.Array.Point3D{k});
        end
        catch;end
            
        
        
    
    end
    catch;end
end
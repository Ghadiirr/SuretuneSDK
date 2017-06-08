classdef merTable < SessionComponent
    %MERTABLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        isBensGunAlignedWithOrientationReference
        targetSide
        middleC0ChannelDepth
        targetChannelDepth
        merDepths
        MATLABid
    end
    
    methods
        function obj = merTable(component_args,label,isBensGunAlignedWithOrientationReference,targetSide,middleC0ChannelDepth,targetChannelDepth,merDepths,id)
        obj@SessionComponent(component_args{:})
        
        obj.label = label;
        obj.isBensGunAlignedWithOrientationReference = isBensGunAlignedWithOrientationReference;
        obj.targetSide = targetSide;
        obj.middleC0ChannelDepth = middleC0ChannelDepth;
        obj.targetChannelDepth = targetChannelDepth;
        obj.merDepths = merDepths;
        obj.MATLABid = id;
        end
        
        
        function obj = set.middleC0ChannelDepth(obj,middleC0ChannelDepth)
            if ~isa(middleC0ChannelDepth,'MerChannelDepth')
               
                path = [obj.path,'.middleC0ChannelDepth'];
                Session = obj.session;
                
                component_args = {path,Session};
                obj.middleC0ChannelDepth = MerChannelDepth(component_args,middleC0ChannelDepth.MerChannelDepth);
                
                
            end
        end
    end
    
end


classdef MerChannelDepth < SessionComponent
    %MERCHANNELDEPTH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        annotation
        remark
        isUncertain
        isStimulated
    end
    
    methods
        function obj = MerChannelDepth(component_args,block)
            obj@SessionComponent(component_args{:});
            
            
            obj.annotation = block.annotation.ref.Attributes.id;
            obj.remark = block.remark;
            obj.isUncertain = block.isUncertain.Attributes.value;
            obj.isStimulated = block.isStimulated.Attributes.value;
        end
    end
    
end


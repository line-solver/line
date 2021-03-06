classdef (Sealed) TimingStrategy
    % Enumeration of timing polcies in petri nets transitions.
    %
    % Copyright (c) 2012-2021, Imperial College London
    % All rights reserved.
    
    properties (Constant)
        Timed = {'timed'};
        Immediate = {'immediate'};
        
        ID_TIMED = 0;
        ID_IMMEDIATE = 1;
    end
    
    methods (Static)
        
        function id = toId(type)
            % ID = TOOD(TYPE)
            
            switch type
                case TimingStrategy.Timed
                    id = ID_TIMED;
                case TimingStrategy.Immediate
                    id = ID_IMMEDIATE;
            end
            
        end
        
        function text = toText(type)
            % TEXT = TOTEXT(TYPE)
            
            switch type
                case TimingStrategy.Timed
                    text = 'Timed Transition';
                case TimingStrategy.Immediate
                    text = 'Immediate Transition';
            end
        end
    end
end


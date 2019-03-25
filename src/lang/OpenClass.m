classdef OpenClass < JobClass
    % A class of jobs that arrive from the external world
    %
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    methods
        
        %Constructor
        function self = OpenClass(model, name, prio)
            self = self@JobClass('open', name);
            if nargin >= 3 && isa(prio,'Source')
                % user error, source passed as ref station
                prio = 0;
            end
            if isempty(model.getSource)
                error('Network require a Source prior to instantiating open classes.');
            end
            if isempty(model.getSink)
                error('Network require a Sink prior to instantiating open classes.');
            end
            
            self.type = 'open';
            self.priority = 0;
            if exist('prio','var')
                self.priority = prio;
            end
            addJobClass(model, self);
            setReferenceStation(self, model.getSource());
            
            % set default scheduling for this class at all nodes
            for i=1:length(model.nodes)
                if ~isempty(model.nodes{i}) && ~isa(model.nodes{i},'Source') && ~isa(model.nodes{i},'Sink') && ~isa(model.nodes{i},'Join')
                    %&& ~isa(model.nodes{i},'Fork')
                    model.nodes{i}.setScheduling(self, SchedStrategy.FCFS);
                end
                if isa(model.nodes{i},'Join')
                    model.nodes{i}.setStrategy(self,JoinStrategy.Standard);
                    model.nodes{i}.setRequired(self,-1);
                end
                if ~isempty(model.nodes{i})
                    %                    && (isa(model.nodes{i},'Queue') || isa(model.nodes{i},'Router'))
                    model.nodes{i}.setRouting(self, 'Random');
                end
            end
        end
        
        function setReferenceStation(class, source)
            if ~isa(source,'Source')
                error('The reference station for an open class must be a Source.');
            end
            setReferenceStation@JobClass(class, source);
        end
    end
    
end


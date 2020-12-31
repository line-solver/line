function [capacity, classcap, dropid] = refreshCapacity(self)
% [CAPACITY, CLASSCAP, DROPRULE] = REFRESHCAPACITY()

% Copyright (c) 2012-2021, Imperial College London
% All rights reserved.
M = getNumberOfStations(self);
K = getNumberOfClasses(self);
C = self.qn.nchains;
% set zero buffers for classes that are disabled
classcap = Inf*ones(M,K);
chaincap = Inf*ones(M,C);
capacity = zeros(M,1);
dropid = -ones(M,C); %DropStrategy.WaitingBuffer
for i=1:M
    station = self.getStationByIndex(i);
    for r=1:K
        if isa(station, 'Place')
            classcap(i,r) = min(station.classCap(r), station.cap);
            dropid(i,r) = DropStrategy.toId(station.input.inputJobClasses{r}{3});
        elseif isnan(self.qn.rates(i,r))
            classcap(i,r) = 0;
            chaincap(i,r) = 0;
        else
            c = find(self.qn.chains(:,r),1,'first'); % chain of class r
            chaincap(i,c) = sum(self.qn.njobs(self.qn.chains(c,:)>0));
            classcap(i,r) = chaincap(i,c);
            if station.classCap(r) >= 0
                classcap(i,r) = min(classcap(i,r), station.classCap(r));
            end
            if station.cap >= 0
                classcap(i,r) = min(classcap(i,r),station.cap);
            end
            if isa(station,'Queue')
                dropid(i,r) = DropStrategy.toId(station.input.inputJobClasses{r}{3});
            end
        end
    end
    capacity(i,1) = min([sum(chaincap(i,:)),sum(classcap(i,:))]);
end
if ~isempty(self.qn) %&& isprop(self.qn,'cap')
    self.qn.cap = capacity;
    self.qn.classcap = classcap;
    self.qn.dropid = dropid;
end
end

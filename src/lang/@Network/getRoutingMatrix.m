function [rt,rtNodes,rtNodesByClass,rtNodesByStation,linksMatrix] = getRoutingMatrix(self, arvRates)
% Copyright (c) 2012-2018, Imperial College London
% All rights reserved.

if ~exist('arvRates','var')
    for r=self.getIndexOpenClasses
        arvRates(r) = 1 / self.getSource.input.sourceClasses{r}{end}.getMean;
    end
end

nodeNames = self.getNodeNames();
% connectivity matrix
linksMatrix = zeros(self.getNumberOfNodes);
for r=1:size(self.links,1)
    i=findstring(nodeNames,self.links{r}{1}.name);
    j=findstring(nodeNames,self.links{r}{2}.name);
    linksMatrix(i,j) = 1;
end

if ~exist('arvRates','var')
    if self.hasOpenClasses()
        error('getRoutingMatrix requires arrival rates for open classes.');
    end
end

K = self.getNumberOfClasses;
NK = self.getNumberOfJobs;
rtNodes = zeros(self.getNumberOfNodes()*K);
% The first loop considers the class at which a job enters the
% target station
for k=1:K
    for i=1:self.getNumberOfNodes()
        switch self.nodes{i}.output.outputStrategy{k}{2}
            case RoutingStrategy.RAND
                if isinf(NK(k)) || (~isa(self.nodes{i},'Source') && ~isa(self.nodes{i},'Sink')) % don't route closed classes out of source nodes
                    for j=1:self.getNumberOfNodes()
                        if linksMatrix(i,j)>0
                            rtNodes((i-1)*K+k,(j-1)*K+k)=1/sum(linksMatrix(i,:));
                        end
                    end
                end
            case RoutingStrategy.PROB
                if isinf(NK(k)) || ~isa(self.nodes{i},'Sink')
                    for t=1:length(self.nodes{i}.output.outputStrategy{k}{end}) % for all outgoing links
                        j = findstring(nodeNames,self.nodes{i}.output.outputStrategy{k}{end}{t}{1}.name);
                        rtNodes((i-1)*K+k,(j-1)*K+k) = self.nodes{i}.output.outputStrategy{k}{end}{t}{2};
                    end
                end
            case {RoutingStrategy.RR, RoutingStrategy.JSQ}
                % we set the routing probabilities for the chain as in
                % RoutingStrategy.RAND
                if isinf(NK(k)) || (~isa(self.nodes{i},'Source') && ~isa(self.nodes{i},'Sink')) % don't route closed classes out of source nodes
                    for j=1:self.getNumberOfNodes()
                        if linksMatrix(i,j)>0
                            rtNodes((i-1)*K+k,(j-1)*K+k)=1/sum(linksMatrix(i,:));
                        end
                    end
                end
            otherwise
                if self.nodes{i}.output.outputStrategy{k}{2}~=0 % disabled
                    error([self.nodes{i}.output.outputStrategy{k}{2},' routing policy is not yet supported.']);
                end
        end
    end
end

% The second loop corrects the first one at nodes that change
% the class of the job in the service section.

for i=1:self.getNumberOfNodes % source
    if isa(self.nodes{i}.server,'StatelessClassSwitch')
        Pi = rtNodes(((i-1)*K+1):i*K,:);
        for r=1:K
            for s=1:K
                Pcs(r,s) = self.nodes{i}.server.csFun(r,s);
            end
        end
        rtNodes(((i-1)*K+1):i*K,:) = 0;
        for j=1:self.getNumberOfNodes() % destination
            Pij = Pi(1:K,((j-1)*K+1):j*K); %Pij(r,s)
            for r=1:self.getNumberOfClasses()
                for s=1:self.getNumberOfClasses()
                    % Find the routing probability section determined by the router section in the first loop
                    %Pnodes(((i-1)*K+1):i*K,((j-1)*K+1):j*K) = Pcs*Pij;
                    rtNodes((i-1)*K+r,(j-1)*K+s) = Pcs(r,s)*Pij(s,s);
                end
            end
        end
    elseif isa(self.nodes{i}.server,'StatefulClassSwitch')
        Pi = rtNodes(((i-1)*K+1):i*K,:);
        for r=1:K
            for s=1:K
                Pcs(r,s) = self.nodes{i}.server.csFun(r,s,[],[]); % get csmask
            end
        end
        rtNodes(((i-1)*K+1):i*K,:) = 0;
        if isa(self.nodes{i}.server,'CacheClassSwitch')
            for r=1:K
                if (isempty(find(r == self.nodes{i}.server.hitClass)) && isempty(find(r == self.nodes{i}.server.missClass)))
                    Pcs(r,:) = Pcs(r,:)/sum(Pcs(r,:));
                end
            end
            for r=1:self.getNumberOfClasses()
                if (isempty(find(r == self.nodes{i}.server.hitClass)) && isempty(find(r == self.nodes{i}.server.missClass)))
                    for j=1:self.getNumberOfNodes() % destination
                        for s=1:self.getNumberOfClasses()
                            Pi((i-1)*K+r,(j-1)*K+s) = 0;
                        end
                    end
                end
            end
            for j=1:self.getNumberOfNodes() % destination
                Pij = Pi(1:K,((j-1)*K+1):j*K); %Pij(r,s)
                for r=1:self.getNumberOfClasses()
                    if ~(isempty(find(r == self.nodes{i}.server.hitClass)) && isempty(find(r == self.nodes{i}.server.missClass)))
                        for s=1:self.getNumberOfClasses()
                            % Find the routing probability section determined by the router section in the first loop
                            %Pnodes(((i-1)*K+1):i*K,((j-1)*K+1):j*K) = Pcs*Pij;
                            rtNodes((i-1)*K+r,(j-1)*K+s) = Pcs(r,s)*Pij(s,s);
                        end
                    end
                end
            end
        end
    end
    
    % ignore all chains containing a Pnodes column that sums to 0,
    % since these are classes that cannot arrive to the node
    % unless this column belongs to the source
    colsToIgnore = find(sum(rtNodes,1)==0);
    if self.hasOpenClasses()
        idxSource = self.getIndexSourceNode;
        colsToIgnore = setdiff(colsToIgnore,(idxSource-1)*K+(1:K));
    end
    
    % We route back from the sink to the source. Since open classes
    % have an infinite population, if there is a class switch QN
    % with the following chains
    % Source -> (A or B) -> C -> Sink
    % Source -> D -> Sink
    % We can re-route class C into the source either as A or B or C.
    % We here re-route back as C and leave for the chain analyzer
    % to detect that C is in a chain with A and B and change this
    % part.
    [C,inChain]=weaklyconncomp(rtNodes+rtNodes');
    inChain(colsToIgnore) = 0;
    chainCandidates = cell(1,C);
    for r=1:C
        chainCandidates{r} = find(inChain==r);
    end
    
    chainsPnodes = []; % columns are classes? rows are definitely chains
    for t=1:length(chainCandidates)
        if length(chainCandidates{t})>1
            chainsPnodes(end+1,unique(mod(chainCandidates{t}-1,K)+1))=1;
        end
    end
    try
        chainsPnodes = sortrows(chainsPnodes,'descend');
    catch % old MATLABs
        chainsPnodes = sortrows(chainsPnodes);
    end
    % this routes open classes back from the sink into the source
    % it will not work with non-renewal arrivals as it choses in which open
    % class to reroute a job with probability depending on the arrival rates
    if self.hasOpenClasses()
        arvRates(isnan(arvRates)) = 0;
        idxSink = self.getIndexSinkNode;
        for s=self.getIndexOpenClasses
            s_chain = find(chainsPnodes(:,s));
            others_in_chain = find(chainsPnodes(s_chain,:));
            rtNodes((idxSink-1)*K+others_in_chain,(idxSource-1)*K+others_in_chain) = repmat(arvRates(others_in_chain)/sum(arvRates(others_in_chain)),length(others_in_chain),1);
        end
    end
    
    % We now obtain the routing matrix P by ignoring the non-stateless
    % nodes and calculating by the stochastic complement method the
    % correct transition probabilities, that includes the effects
    % of the non-station nodes (e.g., ClassSwitch)
    statefulNodesClasses = [];
    for i=self.getIndexStatefulNodes()
        statefulNodesClasses(end+1:end+K)= ((i-1)*K+1):(i*K);
    end
    
    % Hide the nodes that are not stations
    rt = dtmc_stochcomp(rtNodes,statefulNodesClasses);
    if nargout >= 3
        M = self.getNumberOfNodes();
        K = self.getNumberOfClasses();
        rtNodesByClass = cell(K);
        for i=1:M
            for j=1:M
                for r=1:K
                    for s=1:K
                        rtNodesByClass{s,r}(i,j) = rtNodes((i-1)*K+s,(j-1)*K+r);
                    end
                end
            end
        end
    end
    
    if nargout >= 4
        M = self.getNumberOfNodes();
        K = self.getNumberOfClasses();
        rtNodesByStation = cell(K);
        for i=1:M
            for j=1:M
                for r=1:K
                    for s=1:K
                        rtNodesByStation{i,j}(r,s) = rtNodes((i-1)*K+s,(j-1)*K+r);
                    end
                end
            end
        end
    end
end
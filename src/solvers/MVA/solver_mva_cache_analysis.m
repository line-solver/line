function [QN,UN,RN,TN,CN,XN,lG,runtime] = solver_mva_cache_analysis(qn, options)
% [Q,U,R,T,C,X,LG,RUNTIME] = SOLVER_MVA_CACHE_ANALYSIS(QN, OPTIONS)

% Copyright (c) 2012-2019, Imperial College London
% All rights reserved.

T0=tic;
QN = []; UN = [];
RN = []; TN = [];
CN = [];
XN = zeros(1,qn.nclasses);
lG = NaN;

source_ist = qn.nodeToStation(qn.nodetype == NodeType.Source);
sourceRate = qn.rates(source_ist,:);
sourceRate(isnan(sourceRate)) = 0;
TN(source_ist,:) = sourceRate;

ch = qn.varsparam{qn.nodetype == NodeType.Cache};

m = ch.cap;
n = ch.nitems;
h = length(m);
u = qn.nclasses;
lambda = zeros(u,n,h);

for v=1:u
    for k=1:n
        for l=1:(h+1)
            if ~isnan(ch.pref{v})
                lambda(v,k,l) = sourceRate(v) * ch.pref{v}(k);
            end
        end
    end
end

R = ch.accost;

% R={};
% for k=1:n
%     for v=1:u
%         R{v,k} = [
%             0 1
%             0 1];
%     end
% end

[gamma,u,n,h] = mucache_gamma_lp(lambda,R);

[~,missRate] = mucache_miss_asy(gamma,m,lambda);

for r = 1:qn.nclasses
    if length(ch.hitclass)>=r
        XN(ch.missclass(r)) = XN(ch.missclass(r)) + missRate(r);
        XN(ch.hitclass(r)) = XN(ch.hitclass(r)) + (sourceRate(r) - missRate(r));
    end
end
runtime=toc(T0);
end

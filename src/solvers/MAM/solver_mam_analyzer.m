function [QN,UN,RN,TN,CN,XN,runtime] = solver_mam_analyzer(sn, options)
% [QN,UN,RN,TN,CN,XN,RUNTIME] = SOLVER_MAM_ANALYZER(QN, OPTIONS)

% Copyright (c) 2012-2021, Imperial College London
% All rights reserved.

M = sn.nstations;    %number of stations
K = sn.nclasses;    %number of classes

Tstart = tic;

config = struct();
config.merge = 'super';
%config.compress = 'mixture.order1';
config.compress = 'none';
config.space_max = 128;

switch options.method
    case 'dec.mmap'
        % service distributuion per class scaled by utilization used as
        % departure process
        [QN,UN,RN,TN,CN,XN] = solver_mam(sn, options, config);
    case {'default', 'dec.source'}
        % arrival process per chain rescaled by visits at each node
        [QN,UN,RN,TN,CN,XN] = solver_mam_basic(sn, options, config);
    case 'dec.poisson'
        % analyze the network with Poisson streams
        config.space_max = 1;
        [QN,UN,RN,TN,CN,XN] = solver_mam_basic(sn, options, config);
    otherwise
        line_error(mfilename,'Unknown method.');
end

QN(isnan(QN))=0;
CN(isnan(CN))=0;
RN(isnan(RN))=0;
UN(isnan(UN))=0;
XN(isnan(XN))=0;
TN(isnan(TN))=0;

runtime = toc(Tstart);

end

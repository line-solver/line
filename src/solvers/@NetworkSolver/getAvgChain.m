function [QN,UN,RN,TN] = getAvgChain(self,~,~,~,~)
% Return average station metrics aggregated by chain
%
% Copyright (c) 2012-2019, Imperial College London
% All rights reserved.
QN = self.getAvgQLenChain;
UN = self.getAvgUtilChain;
RN = self.getAvgRespTChain;
TN = self.getAvgTputChain;
end

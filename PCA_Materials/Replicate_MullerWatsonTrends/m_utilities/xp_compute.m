function [um,xp1] = xp_compute(u,q);
% This computes Cosine Transform and mean
%   Inputs
%      u = series of interest  (Tx1)
%      q = number of cosine transforms
%   Outputs    
%     um = mean of u
%     xp1 = cosine transform
   um = mean(u);
   psi = psi_compute(size(u,1),q);
   udm = u-repmat(um,size(u,1),1);
   xp1 = (psi')*udm;
end


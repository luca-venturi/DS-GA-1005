function decoded = estimate_code( marg )
% ESTIMATE_CODE - Estimates a codeword based on its marginal distributions.
%   This returns the most likely value of each bit under the marginals.
%
% Inputs:
%   marg: nx1 cell array where each cell is the marginal vector for that bit
%
% Outputs:
%    decoded: nx1 vector containing the estimated codeword

  n = numel(marg);
  decoded = zeros(n,1);
  
  % FILL IN THE REST OF THE CODE
end


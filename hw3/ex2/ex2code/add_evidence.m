function G = add_evidence( G, var_id, val )
% ADD_EVIDENCE - Adds the "evidence" that variable with ID 'var_id' takes
%   on value 'val'.  This slices the factors neighboring var_id accordingly
%   and returns the updated factor graph structure.
%
% Brown CS242

  % iterate factor neighbors
  nbrs = G.var(var_id).nbrs_fac;
  for fac_i = 1:numel(nbrs)
    fac_id = nbrs(fac_i);
    this_fac = G.fac(fac_id);
    
%     % special case: singleton factor
%     if numel(this_fac.nbrs_var) == 1
%       new_p = zeros(numel(this_fac.p), 1);
%       new_p(val) = 1;
%       this_fac.p = new_p;
%       continue;
%     end
    
    % slice factor
    I = find( this_fac.nbrs_var == var_id );
    index = repmat( {':'}, numel(this_fac.nbrs_var), 1 );
    index(I) = {val};
    new_p = this_fac.p( index{:} );
    new_nbrs_var = this_fac.nbrs_var;
    new_nbrs_var(I) = [];
    
    % adjust dimensions
    if I==1
      new_p = shiftdim(new_p, 1);
    else
      new_p = squeeze( new_p );
    end
    
    % save factor
    this_fac.p = squeeze( new_p );    
    this_fac.nbrs_var = new_nbrs_var;
    G.fac(fac_id) = this_fac;
  end
  
  % remove edges from var node
  G.var(var_id).nbrs_fac = [];  
  G.var(var_id).observed = val;
end

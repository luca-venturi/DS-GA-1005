function [ var_id ] = get_varid( G, name )
% GET_VARID - Returns the variable index given the name.  This is a naive
% linear-time operation that scans the list of variables.
%
% Brown CS242

  for var_id = 1:numel(G.var)
    if strcmp(lower(G.var(var_id).name), lower(name))
      return;
    end    
  end
  var_id = [];
end


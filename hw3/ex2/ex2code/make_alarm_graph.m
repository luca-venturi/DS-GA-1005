function G = make_alarm_graph()
% MAKE_ALARM_GRAPH - Constructs a factor graph data structure for the Alarm
%   Network dataset.  The factor graph data structure consists of the
%   following fields:
%
%   var - Struct array of variable nodes
%   fac - Struct array of factor nodes
%
% The variable data structure consists of the fields:
%
%   name - Variable name (string)
%   id - Unique identifier (integer)
%   nbrs_fac - ID of neighboring factor nodes (integer)
%   dim - Number of values variable can take on (integer)
%   observed - 0 if hidden, otherwise equals observed value (integer)
%
% The factor data structure consists of the fields:
%
%   p - Multidimensional array of potential values.  The dimensions are
%       aligned with the ordering of variables in nbrs_var (integer multiarray).
%   nbrs_var - Ordered IDs of neighboring variables, this is also the 
%       "domain" of the factor (integer array).
%   id - Unique identifier (integer)
%
% Brown CS242

  G = init_graph();
  
  % MINVOLSET
  [G, id_MINVOLSET] = add_varnode(G, 'MINVOLSET', 3); 
  p = [ 0.05; 0.9; 0.05 ];
  G = add_facnode(G, p, id_MINVOLSET);
  
  % VENTMACH | MINVOLSET
  [G, id_VENTMACH] = add_varnode(G, 'VENTMACH', 4); 
  p = zeros(4,3);
  p(:,1) = [ 0.05, 0.93, 0.01, 0.01 ];
  p(:,2) = [ 0.05, 0.01, 0.93, 0.01 ];
  p(:,3) = [ 0.05, 0.01, 0.01, 0.93 ];
  G = add_facnode(G, p, id_VENTMACH, id_MINVOLSET);
  
  % DISCONNECT
  [G, id_DISCONNECT] = add_varnode(G, 'DISCONNECT', 2); 
  p = [ 0.1; 0.9 ];
  G = add_facnode(G, p, id_DISCONNECT);
  
  % VENTTUBE | VENTMACH, DISCONNECT
  [G, id_VENTTUBE] = add_varnode(G, 'VENTTUBE',4); 
  p = zeros(4,4,2);
  p(:,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,3,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,3,2) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,4,1) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,4,2) = [ 0.01, 0.01, 0.01, 0.97 ];
  G = add_facnode(G, p, id_VENTTUBE, id_VENTMACH, id_DISCONNECT);
  
  % PULMEMBOLUS
  [G, id_PULMEMBOLUS] = add_varnode(G, 'PULMEMBOLUS',2); 
  p = [ 0.01; 0.99 ];
  G = add_facnode(G, p, id_PULMEMBOLUS);
  
  % INTUBATION
  [G, id_INTUBATION] = add_varnode(G, 'INTUBATION',3); 
  p = [ 0.92; 0.03; 0.05 ];
  G = add_facnode(G, p, id_INTUBATION);
  
  % PAP | PULMEMBOLUS
  [G, id_PAP] = add_varnode(G, 'PAP',3); 
  p = zeros(3,2);  
  p(:,1) = [ 0.01, 0.19, 0.8 ];
  p(:,2) = [ 0.05, 0.9, 0.05 ];
  G = add_facnode(G, p, id_PAP, id_PULMEMBOLUS);
  
  % SHUNT | PULMEMBOLUS, INTUBATION
  [G, id_SHUNT] = add_varnode(G, 'SHUNT',2); 
  p = zeros(2,2,3);
  p(:,1,1) = [ 0.1, 0.9 ];
  p(:,1,2) = [ 0.1, 0.9 ];
  p(:,1,3) = [ 0.01, 0.99 ];
  p(:,2,1) = [ 0.95, 0.05 ];
  p(:,2,2) = [ 0.95, 0.05 ];
  p(:,2,3) = [ 0.05, 0.95 ];
  G = add_facnode(G, p, id_SHUNT, id_PULMEMBOLUS, id_INTUBATION);
  
  % KINKEDTUBE
  [G, id_KINKEDTUBE] = add_varnode(G, 'KINKEDTUBE',2);   
  p = [ 0.04; 0.96];
  G = add_facnode(G, p, id_KINKEDTUBE);
  
  % PRESS | VENTTUBE, KINKEDTUBE, INTUBATION
  [G, id_PRESS] = add_varnode(G, 'PRESS',4); 
  p = zeros(4,4,2,3);
  p(:,1,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,1,2) = [ 0.01, 0.3, 0.49, 0.2 ];
  p(:,1,1,3) = [ 0.01, 0.01, 0.08, 0.9 ];
  p(:,1,2,1) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,1,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,2,3) = [ 0.1, 0.84, 0.05, 0.01 ];
  p(:,2,1,1) = [ 0.05, 0.25, 0.25, 0.45 ];
  p(:,2,1,2) = [ 0.01, 0.15, 0.25, 0.59 ];
  p(:,2,1,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,2,1) = [ 0.01, 0.29, 0.3, 0.4 ];
  p(:,2,2,2) = [ 0.01, 0.01, 0.08, 0.9 ];
  p(:,2,2,3) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,3,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,3,1,2) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,3,1,3) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,3,2,1) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,3,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,3,2,3) = [ 0.4, 0.58, 0.01, 0.01 ];
  p(:,4,1,1) = [ 0.2, 0.75, 0.04, 0.01 ];
  p(:,4,1,2) = [ 0.2, 0.7, 0.09, 0.01 ];
  p(:,4,1,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,2,1) = [ 0.010000001, 0.90000004, 0.080000006, 0.010000001 ];
  p(:,4,2,2) = [ 0.01, 0.01, 0.38, 0.6 ];
  p(:,4,2,3) = [ 0.01, 0.01, 0.01, 0.97 ];
  G = add_facnode(G, p, id_PRESS, id_VENTTUBE, id_KINKEDTUBE, id_INTUBATION);
  
  % VENTLUNG | VENTTUBE, KINKEDTUBE, INTUBATION
  [G, id_VENTLUNG] = add_varnode(G, 'VENTLUNG',4); 
  p = zeros(4,4,2,3);
  p(:,1,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,1,2) = [ 0.95000005, 0.030000001, 0.010000001, 0.010000001 ];
  p(:,1,1,3) = [ 0.4, 0.58, 0.01, 0.01 ];
  p(:,1,2,1) = [ 0.3, 0.68, 0.01, 0.01 ];
  p(:,1,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,2,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,1,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,1,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,2,1) = [ 0.95000005, 0.030000001, 0.010000001, 0.010000001 ];
  p(:,2,2,2) = [ 0.5, 0.48, 0.01, 0.01 ];
  p(:,2,2,3) = [ 0.3, 0.68, 0.01, 0.01 ];
  p(:,3,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,3,1,2) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,3,1,3) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,3,2,1) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,3,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,3,2,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,1,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,1,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,2,1) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,4,2,2) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,4,2,3) = [ 0.01, 0.01, 0.01, 0.97 ];
  G = add_facnode(G, p, id_VENTLUNG, id_VENTTUBE, id_KINKEDTUBE, id_INTUBATION);
  
  % FIO2
  [G, id_FIO2] = add_varnode(G, 'FIO2',2); 
  p = [ 0.05; 0.95 ];
  G = add_facnode(G, p, id_FIO2);
  
  % MINVOL | VENTLUNG, INTUBATION
  [G, id_MINVOL] = add_varnode(G, 'MINVOL',4); 
  p = zeros(4, 4, 3);
  p(:,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,2) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,1,3) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,2,1) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,3) = [ 0.6, 0.38, 0.01, 0.01 ];
  p(:,3,1) = [ 0.5, 0.48, 0.01, 0.01 ];
  p(:,3,2) = [ 0.5, 0.48, 0.01, 0.01 ];
  p(:,3,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,1) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,4,2) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,4,3) = [ 0.01, 0.01, 0.01, 0.97 ];
  G = add_facnode(G, p, id_MINVOL, id_VENTLUNG, id_INTUBATION);
  
  % VENTALV | VENTLUNG, INTUBATION
  [G, id_VENTALV] = add_varnode(G, 'VENTALV',4); 
  p = zeros(4,4,3);
  p(:,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,2) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,1,3) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,2,1) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,3) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,3,1) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,3,2) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,3,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,1) = [ 0.030000001, 0.95000005, 0.010000001, 0.010000001 ];
  p(:,4,2) = [ 0.01, 0.94, 0.04, 0.01 ];
  p(:,4,3) = [ 0.01, 0.88, 0.1, 0.01 ];
  G = add_facnode(G, p, id_VENTALV, id_VENTLUNG, id_INTUBATION);
  
  % ANAPHYLAXIS
  [G, id_ANAPHYLAXIS] = add_varnode(G, 'ANAPHYLAXIS',2); 
  p = [ 0.01; 0.99 ];
  G = add_facnode(G, p, id_ANAPHYLAXIS);
  
  % PVSAT | VENTALV, FIO2
  [G, id_PVSAT] = add_varnode(G, 'PVSAT',3); 
  p = zeros(3,4,2);
  p(:,1,1) = [ 1.0, 0.0, 0.0 ];
  p(:,1,2) = [ 0.99, 0.01, 0.0 ];
  p(:,2,1) = [ 0.95, 0.04, 0.01 ];
  p(:,2,2) = [ 0.95, 0.04, 0.01 ];
  p(:,3,1) = [ 1.0, 0.0, 0.0 ];
  p(:,3,2) = [ 0.95, 0.04, 0.01 ];
  p(:,4,1) = [ 0.01, 0.95, 0.04 ];
  p(:,4,2) = [ 0.01, 0.01, 0.98 ];
  G = add_facnode(G, p, id_PVSAT, id_VENTALV, id_FIO2);
  
  % ARTCO2 | VENTALV
  [G, id_ARTCO2] = add_varnode(G, 'ARTCO2',3); 
  p = zeros(3,4);
  p(:,1) = [ 0.01, 0.01, 0.98 ];
  p(:,2) = [ 0.01, 0.01, 0.98 ];
  p(:,3) = [ 0.04, 0.92, 0.04 ];
  p(:,4) = [ 0.9, 0.09, 0.01 ];
  G = add_facnode(G, p, id_ARTCO2, id_VENTALV);
  
  % TPR | ANAPHYLAXIS
  [G, id_TPR] = add_varnode(G, 'TPR',3); 
  p = zeros(3,2);
  p(:,1) = [ 0.98, 0.01, 0.01 ];
  p(:,2) = [ 0.3, 0.4, 0.3 ];
  G = add_facnode(G, p, id_TPR, id_ANAPHYLAXIS);
  
  % SAO2 | SHUNT, PVSAT
  [G, id_SAO2] = add_varnode(G, 'SAO2',3);   
  p = zeros(3, 2, 3);
  p(:,1,1) = [ 0.98, 0.01, 0.01 ];
  p(:,1,2) = [ 0.01, 0.98, 0.01 ];
  p(:,1,3) = [ 0.01, 0.01, 0.98 ];
  p(:,2,1) = [ 0.98, 0.01, 0.01 ];
  p(:,2,2) = [ 0.98, 0.01, 0.01 ];
  p(:,2,3) = [ 0.69, 0.3, 0.01 ];
  G = add_facnode(G, p, id_SAO2, id_SHUNT, id_PVSAT);
  
  % INSUFFANESTH
  [G, id_INSUFFANESTH] = add_varnode(G, 'INSUFFANESTH',2);       
  p = [ 0.1; 0.9];
  G = add_facnode(G, p, id_INSUFFANESTH);
  
  % EXPCO2 | VENTLUNG, ARTCO2
  [G, id_EXPCO2] = add_varnode(G, 'EXPCO2',4); 
  p = zeros(4,4,3);
  p(:,1,1) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,1,2) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,1,3) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,2,1) = [ 0.01, 0.97, 0.01, 0.01 ];
  p(:,2,2) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,2,3) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,3,1) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,3,2) = [ 0.01, 0.01, 0.97, 0.01 ];
  p(:,3,3) = [ 0.97, 0.01, 0.01, 0.01 ];
  p(:,4,1) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,4,2) = [ 0.01, 0.01, 0.01, 0.97 ];
  p(:,4,3) = [ 0.01, 0.01, 0.01, 0.97 ];
  G = add_facnode(G, p, id_EXPCO2, id_VENTLUNG, id_ARTCO2);
  
  % LVFAILURE
  [G, id_LVFAILURE] = add_varnode(G, 'LVFAILURE',2); 
  p = [ 0.05; 0.95 ];
  G = add_facnode(G, p, id_LVFAILURE);
  
  % HYPOVOLEMIA
  [G, id_HYPOVOLEMIA] = add_varnode(G, 'HYPOVOLEMIA',2); 
  p = [ 0.2; 0.8 ];
  G = add_facnode(G, p, id_HYPOVOLEMIA);
  
  % CATECHOL | TPR, SAO2, INSUFFANESTH, ARTCO2
  [G, id_CATECHOL] = add_varnode(G, 'CATECHOL',2); 
  p = zeros(2,3,3,2,3);
  p(:,1,1,1,1) = [ 0.01, 0.99 ];
  p(:,1,1,1,2) = [ 0.01, 0.99 ];
  p(:,1,1,1,3) = [ 0.01, 0.99 ];
  p(:,1,1,2,1) = [ 0.01, 0.99 ];
  p(:,1,1,2,2) = [ 0.01, 0.99 ];
  p(:,1,1,2,3) = [ 0.01, 0.99 ];
  p(:,1,2,1,1) = [ 0.01, 0.99 ];
  p(:,1,2,1,2) = [ 0.01, 0.99 ];
  p(:,1,2,1,3) = [ 0.01, 0.99 ];
  p(:,1,2,2,1) = [ 0.01, 0.99 ];
  p(:,1,2,2,2) = [ 0.01, 0.99 ];
  p(:,1,2,2,3) = [ 0.01, 0.99 ];
  p(:,1,3,1,1) = [ 0.01, 0.99 ];
  p(:,1,3,1,2) = [ 0.01, 0.99 ];
  p(:,1,3,1,3) = [ 0.01, 0.99 ];
  p(:,1,3,2,1) = [ 0.05, 0.95 ];
  p(:,1,3,2,2) = [ 0.05, 0.95 ];
  p(:,1,3,2,3) = [ 0.01, 0.99 ];
  
  p(:,2,1,1,1) = [ 0.01, 0.99 ];
  p(:,2,1,1,2) = [ 0.01, 0.99 ];
  p(:,2,1,1,3) = [ 0.01, 0.99 ];
  p(:,2,1,2,1) = [ 0.05, 0.95 ];
  p(:,2,1,2,2) = [ 0.05, 0.95 ];
  p(:,2,1,2,3) = [ 0.01, 0.99 ];
  p(:,2,2,1,1) = [ 0.05, 0.95 ];
  p(:,2,2,1,2) = [ 0.05, 0.95 ];
  p(:,2,2,1,3) = [ 0.01, 0.99 ];
  p(:,2,2,2,1) = [ 0.05, 0.95 ];
  p(:,2,2,2,2) = [ 0.05, 0.95 ];
  p(:,2,2,2,3) = [ 0.01, 0.99 ];
  p(:,2,3,1,1) = [ 0.05, 0.95 ];
  p(:,2,3,1,2) = [ 0.05, 0.95 ];
  p(:,2,3,1,3) = [ 0.01, 0.99 ];
  p(:,2,3,2,1) = [ 0.05, 0.95 ];
  p(:,2,3,2,2) = [ 0.05, 0.95 ];
  p(:,2,3,2,3) = [ 0.01, 0.99 ];
  
  p(:,3,1,1,1) = [ 0.7, 0.3 ];
  p(:,3,1,1,2) = [ 0.7, 0.3 ];
  p(:,3,1,1,3) = [ 0.1, 0.9 ];
  p(:,3,1,2,1) = [ 0.7, 0.3 ];
  p(:,3,1,2,2) = [ 0.7, 0.3 ];
  p(:,3,1,2,3) = [ 0.1, 0.9 ];
  p(:,3,2,1,1) = [ 0.7, 0.3 ];
  p(:,3,2,1,2) = [ 0.7, 0.3 ];
  p(:,3,2,1,3) = [ 0.1, 0.9 ];
  p(:,3,2,2,1) = [ 0.95, 0.05 ];
  p(:,3,2,2,2) = [ 0.99, 0.01 ];
  p(:,3,2,2,3) = [ 0.3, 0.7 ];
  p(:,3,3,1,1) = [ 0.95, 0.05 ];
  p(:,3,3,1,2) = [ 0.99, 0.01 ];
  p(:,3,3,1,3) = [ 0.3, 0.7 ];
  p(:,3,3,2,1) = [ 0.95, 0.05 ];
  p(:,3,3,2,2) = [ 0.99, 0.01 ];
  p(:,3,3,2,3) = [ 0.3, 0.7 ];
  
  G = add_facnode(G, p, id_CATECHOL, id_TPR, id_SAO2, id_INSUFFANESTH, id_ARTCO2);
  
  % HISTORY | LVFAILURE
  [G, id_HISTORY] = add_varnode(G, 'HISTORY',2); 
  p = zeros(2,2);
  p(:,1) = [ 0.9, 0.1 ];
  p(:,2) = [ 0.01, 0.99 ];
  G = add_facnode(G, p, id_HISTORY, id_LVFAILURE);
  
  % LVEDVOLUME | LVFAILURE, HYPOVOLEMIA
  [G, id_LVEDVOLUME] = add_varnode(G, 'LVEDVOLUME',3); 
  p = zeros(3,2,2);
  p(:,1,1) = [ 0.95, 0.04, 0.01 ];
  p(:,1,2) = [ 0.98, 0.01, 0.01 ];
  p(:,2,1) = [ 0.01, 0.09, 0.9 ];
  p(:,2,2) = [ 0.05, 0.9, 0.05 ];
  G = add_facnode(G, p, id_LVEDVOLUME, id_LVFAILURE, id_HYPOVOLEMIA);
  
  % STROKEVOLUME | LVFAILURE, HYPOVOLEMIA
  [G, id_STROKEVOLUME] = add_varnode(G, 'STROKEVOLUME',3); 
  p = zeros(3,2,2);
  p(:,1,1) = [ 0.98, 0.01, 0.01 ];
  p(:,1,2) = [ 0.95, 0.04, 0.01 ];
  p(:,2,1) = [ 0.5, 0.49, 0.01 ];
  p(:,2,2) = [ 0.05, 0.9, 0.05 ];
  G = add_facnode(G, p, id_STROKEVOLUME, id_LVFAILURE, id_HYPOVOLEMIA);
  
  % ERRLOWOUTPUT
  [G, id_ERRLOWOUTPUT] = add_varnode(G, 'ERRLOWOUTPUT',2); 
  p = [ 0.05; 0.95 ];
  G = add_facnode(G, p, id_ERRLOWOUTPUT);
  
  % HR | CATECHOL
  [G, id_HR] = add_varnode(G, 'HR',3); 
  p = zeros(3, 2);
  p(:,1) = [ 0.05, 0.9, 0.05 ];
  p(:,2) = [ 0.01, 0.09, 0.9 ];
  G = add_facnode(G, p, id_HR, id_CATECHOL);
  
  % ERRCAUTER
  [G, id_ERRCAUTER] = add_varnode(G, 'ERRCAUTER',2); 
  p = [ 0.1; 0.9 ];
  G = add_facnode(G, p, id_ERRCAUTER);
  
  % CVP | LVEDVOLUME
  [G, id_CVP] = add_varnode(G, 'CVP',3); 
  p = zeros(3,3);
  p(:,1) = [ 0.95, 0.04, 0.01 ];
  p(:,2) = [ 0.04, 0.95, 0.01 ];
  p(:,3) = [ 0.01, 0.29, 0.7 ];
  G = add_facnode(G, p, id_CVP, id_LVEDVOLUME);
  
  % PCWP | LVEDVOLUME
  [G, id_PCWP] = add_varnode(G, 'PCWP',3);     
  p = zeros(3,3);
  p(:,1) = [ 0.95, 0.04, 0.01 ];
  p(:,2) = [ 0.04, 0.95, 0.01 ];
  p(:,3) = [ 0.01, 0.04, 0.95 ];
  G = add_facnode(G, p, id_PCWP, id_LVEDVOLUME);
  
  % CO | STROKEVOLUME, HR
  [G, id_CO] = add_varnode(G, 'CO',3);   
  p = zeros(3,3,3);
  p(:,1,1) = [ 0.98, 0.01, 0.01 ];
  p(:,1,2) = [ 0.95, 0.04, 0.01 ];
  p(:,1,3) = [ 0.8, 0.19, 0.01 ];
  p(:,2,1) = [ 0.95, 0.04, 0.01 ];
  p(:,2,2) = [ 0.04, 0.95, 0.01 ];
  p(:,2,3) = [ 0.01, 0.04, 0.95 ];
  p(:,3,1) = [ 0.3, 0.69, 0.01 ];
  p(:,3,2) = [ 0.01, 0.3, 0.69 ];
  p(:,3,3) = [ 0.01, 0.01, 0.98 ];
  G = add_facnode(G, p, id_CO, id_STROKEVOLUME, id_HR);
  
  % HRBP | HR, ERRLOWOUTPUT
  [G, id_HRBP] = add_varnode(G, 'HRBP',3); 
  p = zeros(3,3,2);
  p(:,1,1) = [ 0.98, 0.01, 0.01 ];
  p(:,1,2) = [ 0.4, 0.59, 0.01 ];
  p(:,2,1) = [ 0.3, 0.4, 0.3 ];
  p(:,2,2) = [ 0.98, 0.01, 0.01 ];
  p(:,3,1) = [ 0.01, 0.98, 0.01 ];
  p(:,3,2) = [ 0.01, 0.01, 0.98 ];
  G = add_facnode(G, p, id_HRBP, id_HR, id_ERRLOWOUTPUT);
  
  % HREKG | HR, ERRCAUTER
  [G, id_HREKG] = add_varnode(G, 'HREKG',3); 
  p = zeros(3,3,2);
  p(:,1,1) = [ 0.33333334, 0.33333334, 0.33333334 ];
  p(:,1,2) = [ 0.33333334, 0.33333334, 0.33333334 ];
  p(:,2,1) = [ 0.33333334, 0.33333334, 0.33333334 ];
  p(:,2,2) = [ 0.98, 0.01, 0.01 ];
  p(:,3,1) = [ 0.01, 0.98, 0.01 ];
  p(:,3,2) = [ 0.01, 0.01, 0.98 ];
  G = add_facnode(G, p, id_HREKG, id_HR, id_ERRCAUTER);
  
  % HRSAT | HR, ERRCAUTER
  [G, id_HRSAT] = add_varnode(G, 'HRSAT',3);
  p = zeros(3,3,2);
  p(:,1,1) = [ 0.33333334, 0.33333334, 0.33333334 ];
  p(:,1,2) = [ 0.33333334, 0.33333334, 0.33333334 ];
  p(:,2,1) = [ 0.33333334, 0.33333334, 0.33333334 ];
  p(:,2,2) = [ 0.98, 0.01, 0.01 ];
  p(:,3,1) = [ 0.01, 0.98, 0.01 ];
  p(:,3,2) = [ 0.01, 0.01, 0.98 ];
  G = add_facnode(G, p, id_HRSAT, id_HR, id_ERRCAUTER);
  
  % BP | TPR, CO
  [G, id_BP] = add_varnode(G, 'BP',3);   
  p = zeros(3, 3, 3);
  p(:,1,1) = [ 0.98, 0.01, 0.01 ];
  p(:,1,2) = [  0.98, 0.01, 0.01 ];
  p(:,1,3) = [ 0.9, 0.09, 0.01 ];
  p(:,2,1) = [ 0.98, 0.01, 0.01 ];
  p(:,2,2) = [ 0.1, 0.85, 0.05 ];
  p(:,2,3) = [ 0.05, 0.2, 0.75 ];
  p(:,3,1) = [ 0.3, 0.6, 0.1 ];
  p(:,3,2) = [ 0.05, 0.4, 0.55 ];
  p(:,3,3) = [ 0.01, 0.09, 0.9 ];
  G = add_facnode(G, p, id_BP, id_TPR, id_CO);  
  

end






function G = make_debug_graph()
    G = init_graph();
    nodeNames = {'x1','x2','x3','x4'};
    dims = [2,3,2,2];

    ids = zeros(numel(dims),1);
    for(i=1:numel(dims))
        [G,ids(i)] = add_varnode(G,nodeNames{i},dims(i));
    end

    %add potential for f_3: p(x3)
    p =[0.5;0.5];
    G = add_facnode(G,p,ids(3));

    %add potential for f_4: p(x4)
    p =[0.4;0.6];
    G = add_facnode(G,p,ids(4));

    % add potential for f_{234}: p(x2 | x3, x4)
    p = zeros(3,2,2);
    p(:,1,1) = [0.2,0.4,0.4];
    p(:,1,2) = [0.25,0.25,0.5];
    p(:,2,1) = [0.7,0.15,0.15];
    p(:,2,2) = [0.3,0.65,0.05];
    G = add_facnode(G,p,ids(2),ids(3),ids(4));

    % add potential for f_{12}: p(x1 | x2)
    p = zeros(2,3);
    p(:,1) = [0.5,0.5];
    p(:,2) = [0.7,0.3];
    p(:,3) = [0.2,0.8];
    G = add_facnode(G,p,ids(1),ids(2));
end
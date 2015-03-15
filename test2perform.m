%%Test A effectuer
init;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de dmax

%Initialization for Bunny
nbNeighbors = 15;
gtTransform = [-10,10,3,0.1,-0.05,0.03]
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);

%%%Standard ICP%%%
%Bunny

%Bremen

%%%GICP%%%
%Bunny 

dMax = [ 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 1 1.5 2 3 ];
err_bunny_gicp_dmax = [];
time_bunny_gicp_dmax = [];
for i = 1:size(dMax,2)
    tic
    [A_trans,transformation] = minimization(A,covA,B,covB,gtTransform,iterMax,dMax);
    time_bunny_gicp_dmax(i) = toc
    err_bunny_gicp_dmax(i) = norm(B-A_trans,2);
end
%Bremen


%%%Point 2 Plane%%%

%Bunny

%Bremen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de l'offset (la transformation entre les 2 nuages de points)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparer ICP Closedform et ICP avec generalized framework (sur Bremen ?)

%%Test A effectuer
init;
nbNeighbors = 15;



%% Influence de dmax 

%tranformation for Bunny
gtTransform = [-10,10,3,0.1,-0.05,0.03]

%%%Standard ICP%%%
%Bunny
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);
[A_trans,transformation] = minimization(A,covA,B,covB,gtTransform);
%Bremen

%%%GICP%%%
%Bunny 

%Bremen


%% Influence de l'offset (la transformation entre les 2 nuages de points)


%% Comparer ICP Closedform et ICP avec generalized framework (sur Bremen ?)

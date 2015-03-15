%%Test A effectuer
init;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de dmax
disp('Test influence of d_max on sICP and GICP...');
%Initialization for Bunny
nbNeighbors = 15;
gtTransform = [-10,10,3,0.1,-0.05,0.03]
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);
initTransform = zeros(6,1);
dMax_bunny = [0.02:0.03:0.2, 0.3:0.1:1];
%%%Standard ICP%%%
%Bunny
disp('StandardICP on Bunny...');
err_bunny_sicp_dmax = [];
time_bunny_sicp_dmax = [];
T_bunny_sicp_dmax = [];
for i = 1:size(dMax_bunny,2)
    fprintf('d_max : %d\n',dMax_bunny(i));
    tic;
    [A_trans,transformation,~] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax,dMax(i),false);
    elapsed_time = toc;
    T_bunny_sicp_dmax(i,:) = transformation;
    time_bunny_sicp_dmax(i) = elapsed_time; 
    err_bunny_sicp_dmax(i) = norm(B-A_trans,2);                              
    fprintf('time : %d, err : %d \n',time_bunny_sicp_dmax(i),err_bunny_sicp_dmax(i));
end
disp('StandardICP on Bunny done...');


%Hannover
disp('StandardICP on Hannover...');
dMax_hannover = [10:10:100 500 1000 2000];
%load data
[A,covA,poseA] = loadDBData('data/hannover1/scan000',nbNeighbors);
[B,covB,poseB] = loadDBData('data/hannover1/scan005',nbNeighbors);
err_hannover_sicp_dmax = [];
time_hannover_sicp_dmax = [];
T_hannover_sicp_dmax = [];
for i = 1:size(dMax_hannover,2)
    fprintf('d_max : %d\n',dMax_bunny(i));
    tic;
    [A_trans,transformation,~] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax,dMax(i),false);
    elapsed_time = toc;
    T_hannover_sicp_dmax(i,:) = transformation;
end
disp('StandardICP on Hannover done...'); 
    
    
%%%GICP%%%
%Bunny 

disp('GICP for Bunny...');
err_bunny_gicp_dmax = [];
time_bunny_gicp_dmax = [];
T_bunny_gicp_dmax = [];
for i = 1:size(dMax_bunny,2)
    fprintf('d_max : %d\n',dMax_bunny(i));
    tic
    [A_trans,transformation,~] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax,dMax(i),true);
    elapsed_time = toc;
    T_bunny_gicp_dmax(i,:) = transformation;
    time_bunny_gicp_dmax(i) = elapsed_time; 
    err_bunny_gicp_dmax(i) = norm(B-A_trans,2);                              
    fprintf('time : %d, err : %d \n',time_bunny_gicp_dmax(i),err_bunny_gicp_dmax(i));
end

%Hannover
%Hannover
disp('GICP on Hannover...');
dMax_hannover = [10:10:100 500 1000 2000];
%load data
[A,covA,poseA] = loadDBData('data/hannover1/scan000',nbNeighbors);
[B,covB,poseB] = loadDBData('data/hannover1/scan005',nbNeighbors);
err_hannover_gicp_dmax = [];
time_hannover_gicp_dmax = [];
T_hannover_gicp_dmax = [];
for i = 1:size(dMax_hannover,2)
    fprintf('d_max : %d\n',dMax_hannover(i));
    tic;
    [A_trans,transformation,~] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax,dMax(i),false);
    elapsed_time = toc;
    T_hannover_gicp_dmax(i,:) = transformation;
end
disp('StandardICP on Hannover done...'); 
%%%Point 2 Plane%%%

%Bunny

%Hannover
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de l'offset (la transformation entre les 2 nuages de points)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparer ICP Closedform et ICP avec generalized framework (sur Bremen ?)

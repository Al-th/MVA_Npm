%%Test A effectuer
clear; clc;
init;

subsampling = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de dmax
disp('Test influence of d_max on sICP and GICP...');

%%
%Test on Bunny
disp('Process on Bunny.asc');
%Initialization for Bunny
nbNeighbors = 20;
gtTransform = [-10,10,3,0.1,-0.05,0.03];
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);
initTransform = gtTransform;
initTransform(1:3) = degtorad(initTransform(1:3))
initTransform(1) = initTransform(1)+degtorad(5);
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(3) = initTransform(3)-degtorad(10);
initTransform(4) = initTransform(4)+0.1;
initTransform(5) = initTransform(5)+0.1;
initTransform(6) = initTransform(6);
%Subsample 
A = A(1:subsampling:end,:);
covA = covA(1:subsampling:end,:,:);
B = B(1:subsampling:end,:);
covB = covB(1:subsampling:end,:,:);
%%
%Define value of dMax to test
dMax_bunny = [0.02:0.01:0.1 0.1 0.2 0.3 0.4 0.6 0.8 1];
iterMax = [150 50];

%Define param to store results
info_sicp = {};
info_gicp = {};

%%
for i = 1:size(dMax_bunny,2)
    fprintf('### d_max : %d, number %d/%d###\n',dMax_bunny(i),i,size(dMax_bunny,2));
    disp('Compute transformation by StandardICP');
    tic;
    [A_trans,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(1),dMax_bunny(i),false);
    elapsed_time = toc;
    info_sicp.dMax = dMax_bunny(i);
    info_sicp.time = elapsed_time;
    info_sicp.average_error = computeAverageErrorWithNN(B,A_trans);
    info_sicp.evolution_transformation = evol_T;
    info_sicp.size_subset = size_subset;
    %info_sicp{i}.estimate_transformation = transformation;
    fprintf('time : %.2f, err : %.2d ,converge in %.0f iterations.\n',...
        elapsed_time,norm(B-A_trans,2),size(size_subset,2));
    
    save(sprintf('./Test/info_dmax_bunny_sicp_%-4.2f.mat',dMax_bunny(i)),'info_sicp');
    
    
    disp('Compute transformation by Generalized ICP');
    tic
    [A_trans,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(2),dMax_bunny(i),true);
    elapsed_time = toc;    
    info_gicp.dMax = dMax_bunny(i);
    info_gicp.time = elapsed_time;
    info_gicp.average_error =  computeAverageErrorWithNN(B,A_trans);
    info_gicp.evolution_transformation = evol_T;
    info_gicp.size_subset = size_subset;
    %info_gicp{i}.estimate_transformation = transformation;                        
    fprintf('time : %.2f, err : %.2d ,converge in %f iterations. \n',...
        elapsed_time, info_gicp.average_error ,size(size_subset,2));    
    save(sprintf('./Test/info_dmax_bunny_gicp_%-4.2f.mat',dMax_bunny(i)),'info_gicp');
    
end
disp('SICP and GICP on Bunny done...');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de l'offset (la transformation entre les 2 nuages de points)
%On fait varier Rx sur Bunny : 
disp('Test Different value of Rx for the Transformation on GICP...');

%%
%Test on Bunny
disp('Process on Bunny.asc');
%Initialization for Bunny
nbNeighbors = 20;
gtTransform = [-10,0,0,0.1,-0.2,0.1];
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);
initTransform = gtTransform;
initTransform(1:3) = degtorad(initTransform(1:3));
initTransform(1) = initTransform(1)-degtorad(5);
initTransform(2) = initTransform(2)+degtorad(5);
initTransform(3) = initTransform(3);
initTransform(4) = initTransform(4)+0.1;
initTransform(5) = initTransform(5)-0.1;
initTransform(6) = initTransform(6);
%Subsample 
A = A(1:subsampling:end,:);
covA = covA(1:subsampling:end,:,:);
B = B(1:subsampling:end,:);
covB = covB(1:subsampling:end,:,:);
%%
%Define number of Rx to test
nb_Rx = 10;
step_Rx = 5;

dMax = 0.1;
iterMax = [150 50];
%Define param to store results
info_gicp = {};

%%
for i = 1:nb_Rx
    initTransform(1) = initTransform(1)-degtorad(5);
    fprintf('### Rx : %d, number %d/%d###\n',radtodeg(initTransform(1)),i,nb_Rx);
    tic
    [A_trans,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(2),dMax,true);
    elapsed_time = toc;    
    info_gicp.Rx = radtodeg(initTransform(1));
    info_gicp.time = elapsed_time;
    info_gicp.average_error = norm(B-A_trans,2);
    info_gicp.evolution_transformation = evol_T;
    info_gicp.size_subset = size_subset;
    %info_gicp{i}.estimate_transformation = transformation;                        
    fprintf('time : %.2f, err : %.2d ,converge in %f iterations. \n',...
        elapsed_time, info_gicp.average_error ,size(size_subset,2));    
    save(sprintf('./Test/info_Rx_bunny_gicp_%-4.1f.mat',radtodeg(initTransform(1))),'info_gicp');
 
end
disp('Test differents value for Rx done');

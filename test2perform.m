%%Test A effectuer
clear; clc;
init;

subsampling = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de dmax
disp('Test influence of d_max on sICP and GICP...');

%%
%Test on Bunny
disp('Process on Bunny.asc');
%Initialization for Bunny
nbNeighbors = 15;
gtTransform = [-10,10,3,0.1,-0.05,0.03];
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);
initTransform = zeros(6,1);
%Subsample 
A = A(1:subsampling:end,:);
covA = covA(1:subsampling:end,:,:);
B = B(1:subsampling:end,:);
covB = covB(1:subsampling:end,:,:);
%%
%Define value of dMax to test
dMax_bunny = [0.02:0.03:0.2, 0.3:0.1:1];
iterMax = [150 50];

%Define param to store results
info_sicp = {};
info_gicp = {};

%%
for i = 1:size(dMax_bunny,2)
    fprintf('### d_max : %d, number %d/%d###\n',dMax_bunny(i),i,size(dMax_bunny,2));
    disp('Compute transformation by StandardICP');
    tic;
    [A_trans,transformation,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(1),dMax_bunny(i),false);
    elapsed_time = toc;
    info_sicp{i}.dMax = dMax_bunny(i);
    info_sicp{i}.time = elapsed_time;
    info_sicp{i}.average_error = norm(B-A_trans,2);
    info_sicp{i}.evolution_transformation = evol_T;
    info_sicp{i}.size_subset = size_subset;
    info_sicp{i}.estimate_transformation = transformation;
    fprintf('time : %.2f, err : %.2d ,converge in %.0f iterations.\n',...
        elapsed_time,norm(B-A_trans,2),size(size_subset,2));
    
    disp('Compute transformation by Generalized ICP');
    tic
    [A_trans,transformation,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(2),dMax_bunny(i),true);
    elapsed_time = toc;    
    info_gicp{i}.dMax = dMax_bunny(i);
    info_gicp{i}.time = elapsed_time;
    info_gicp{i}.average_error = norm(B-A_trans,2);
    info_gicp{i}.evolution_transformation = evol_T;
    info_gicp{i}.size_subset = size_subset;
    info_gicp{i}.estimate_transformation = transformation;                        
    fprintf('time : %.2f, err : %.2d ,converge in %f iterations. \n',...
        elapsed_time, info_gicp{i}.average_error ,size(size_subset,2));    
end
save('./Test/info_dmax_bunny_sicp.mat','info_sicp');
save('./Test/info_dmax_bunny_gicp.mat','info_gicp');


disp('SICP and GICP on Bunny done...');


%%
%Test on Hannover
disp('Process on Hannover database : scan000 and scan005');
%Initialization : loading data and define intial transformation
nbNeighbors = 20;
%load data
[A,covA,poseA] = loadDBData('data/hannover1/scan000',nbNeighbors);
[B,covB,poseB] = loadDBData('data/hannover1/scan005',nbNeighbors);
%define ground Truth transformation
gtTransform(1) = poseA(2,1)-poseB(2,1);
gtTransform(2) = poseA(2,2)-poseB(2,2);
gtTransform(3) = poseA(2,3)-poseB(2,3);
gtTransform(4) = poseA(1,1)-poseB(1,1);
gtTransform(5) = poseA(1,2)-poseB(1,2);
gtTransform(6) = poseA(1,3)-poseB(1,3);
clear poseA;
clear poseB;
initTransform = gtTransform;

initTransform(1:3) = degtorad(initTransform(1:3));
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(4) = -initTransform(4)+20;
initTransform(6) = initTransform(6)+10;

%Subsample 
A = A(1:subsampling:end,:);
covA = covA(1:subsampling:end,:,:);
B = B(1:subsampling:end,:);
covB = covB(1:subsampling:end,:,:);
%%
%Define value of dMax to test
dMax_hannover = [50 100:100:500 1000 2000];
iterMax = [150 50];

%Define param to store results
info_sicp = {};
info_gicp = {};

%%

for i = 1:size(dMax_hannover,2)
    fprintf('### d_max : %d, number %d/%d###\n',dMax_hannover(i),i,size(dMax_hannover,2));
    disp('Compute transformation by StandardICP');
    close all;
    tic;
    [A_trans,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(1),dMax_hannover(i),false);
    elapsed_time = toc;
    info_sicp{i}.dMax = dMax_hannover(i);
    info_sicp{i}.time = elapsed_time;
    info_sicp{i}.average_error = computeAverageErrorWithNN(B,A_trans);
    info_sicp{i}.evolution_transformation = evol_T;
    info_sicp{i}.size_subset = size_subset;
    info_sicp{i}.estimate_transformation = evol_T(end,:);
    fprintf('time : %.2f, err : %.2d ,converge in %.0f iterations.\n',...
            elapsed_time,info_sicp{i}.average_error,size(size_subset,2));
    
    disp('Compute transformation by Generalized ICP');
    close all;
    tic
    [A_trans,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(2),dMax_hannover(i),true);
    elapsed_time = toc; 
    
    info_gicp{i}.dMax = dMax_hannover(i);
    info_gicp{i}.time = elapsed_time;
    info_gicp{i}.average_error = computeAverageErrorWithNN(B,A_trans);
    info_gicp{i}.evolution_transformation = evol_T;
    info_gicp{i}.size_subset = size_subset;
    info_gicp{i}.estimate_transformation = evol_T(end,:);                        
    fprintf('time : %.2f, err : %.2d ,converge in %f iterations. \n',...
            elapsed_time,info_gicp{i}.average_error,size(size_subset,2));
        
    save(['./Test/info_dmax_hannover_sicp' int2str(i) '.mat'],'info_sicp');
    save(['./Test/info_dmax_hannover_gicp' int2str(i) '.mat'],'info_gicp');
end


disp('SICP and GICP on Bunny done...');

disp('Test influence terminated...');
%%%Point 2 Plane%%%

%Bunny

%Hannover
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Influence de l'offset (la transformation entre les 2 nuages de points)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparer ICP Closedform et ICP avec generalized framework (sur Bremen ?)

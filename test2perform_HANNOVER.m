%%Test A effectuer
clear; clc;
init;

subsampling = 10;

%%
%Test on Hannover
disp('Process on Hannover database : scan000 and scan004');
%Initialization : loading data and define intial transformation
nbNeighbors = 20;
%load data
[A,covA,poseA] = loadDBData('data/hannover1/scan000',nbNeighbors);
[B,covB,poseB] = loadDBData('data/hannover1/scan004',nbNeighbors);
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

initTransform(1:3) = degtorad(initTransform(1:3))
initTransform(1) = initTransform(1)+degtorad(5);
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(3) = initTransform(3)-degtorad(10);
initTransform(4) = -initTransform(4)+20;
initTransform(5) = initTransform(5)-10;
initTransform(6) = initTransform(6)+15;

initTransform

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
disp('Test influence dMax terminated...');


%% Comparer ICP Closedform et ICP avec generalized framework (sur Bremen ?)

info_icpclosedform = {};

for i = 1:size(dMax_hannover,2)
    fprintf('### d_max : %d, number %d/%d###\n',dMax_hannover(i),i,size(dMax_hannover,2));
    disp('Compute transformation by StandardICP : Closed form');
    close all;
    tic;
    
    [A_trans,evol_T,size_subset] = ICP_ClosedForm(A,B,initTransform,100,dMax_hannover(i));
    
    elapsed_time = toc;
    info_icpclosedform{i}.dMax = dMax_hannover(i);
    info_icpclosedform{i}.time = elapsed_time;
    info_icpclosedform{i}.average_error = computeAverageErrorWithNN(B,A_trans);
    info_icpclosedform{i}.evolution_transformation = evol_T;
    info_icpclosedform{i}.size_subset = size_subset;

    info_icpclosedform{i}.estimate_transformation = evol_T(end,:);
    fprintf('time : %.2f, err : %.2d ,converge in %.0f iterations.\n',...
            elapsed_time,info_icpclosedform{i}.average_error,size(size_subset,2));
    save(['./Test/info_dmax_hannover_sicpclosedform' int2str(i) '.mat'],'info_icpclosedform');

end

%%Test A effectuer
clear; clc;
init;

subsampling = 20;

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

n_sicp = [];
n_gicp = [];
subset_sicp = [];
subset_gicp = [];
nb_iter_sicp = [];
nb_iter_gicp = [];
dm = [];
for i = 1:size(dMax_bunny,2)
    fileName = sprintf('./Test/info_dmax_bunny_gicp_%-4.2f.mat',dMax_bunny(i));
    tempInfo = load(fileName);
    tempInfo = tempInfo.info_gicp;
    endTransformation = tempInfo.evolution_transformation(end,:)
    A_trans = transformPointCloud(A,endTransformation);
    err = computeAverageErrorWithNN(B,A_trans)
    n_gicp = [n_gicp err]
    nb_iter_gicp = [nb_iter_gicp size(tempInfo.size_subset,2)];
    subset_gicp = [subset_gicp tempInfo.size_subset(1)]
    
    fileName = sprintf('./Test/info_dmax_bunny_sicp_%-4.2f.mat',dMax_bunny(i));
    tempInfo = load(fileName);
    tempInfo = tempInfo.info_sicp;
    endTransformation = tempInfo.evolution_transformation(end,:)
    A_trans = transformPointCloud(A,endTransformation);
    err = computeAverageErrorWithNN(B,A_trans)
    n_sicp = [n_sicp err]
    nb_iter_sicp = [nb_iter_sicp size(tempInfo.size_subset,2)];
    subset_sicp = [subset_sicp tempInfo.size_subset(1)]
    dm = [dm tempInfo.dMax]
end
%%
figure(1);
hold on;
plot(dm,n_gicp,'r','LineWidth',2);
plot(dm,n_sicp,'b','LineWidth',1);
hold off;
%axis([0 2000 40 70]);
xlabel('dmax (cm)');
ylabel('Average error (cm)');
title('Bunny scans (1529 points)');
legend('Generalized ICP','Standard ICP');

%%
figure(2);
hold on;
plot(dm,subset_sicp,'b','LineWidth',2);
hold off;
%axis([0 2000 40 70]);
xlabel('dmax (cm)');
ylabel('Number of corresponding points');
title('Bunny scans (1529 points)');

%%
figure(7);
hold on;
plot(dm,nb_iter_gicp,'r','LineWidth',2);
plot(dm,nb_iter_sicp,'b','LineWidth',2);
legend('Generalized ICP','Standard ICP');
hold off;
xlabel('dmax (cm)');
ylabel('Number of iteration');
title('Bunny scans (1529 points)');
legend('Generalized ICP','Standard ICP');
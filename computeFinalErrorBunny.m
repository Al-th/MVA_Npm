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

n = [];
dm = [];
for i = 2:size(dMax_bunny,2)
    fileName = sprintf('./Test/info_dmax_bunny_gicp_%-4.2f.mat',dMax_bunny(i));
    tempInfo = load(fileName);
    tempInfo = tempInfo.info_gicp;
    endTransformation = tempInfo.evolution_transformation(end,:)
    A_trans = transformPointCloud(A,endTransformation);
    err = computeAverageErrorWithNN(B,A_trans)
    n = [n err]
    dm = [dm tempInfo.dMax]
end

plot(dm,n.*1000);
xlabel('dmax');
ylabel('Average error (m)');
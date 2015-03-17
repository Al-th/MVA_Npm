init;
subSampleStep = 20;
nbNeighbors = 20;
gtTransform = [-10,10,3,0.1,-0.05,0.03]
%A is a bunny
%B is the A bunny that was subject to a rotation and a translation
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);  
%%
%Subsample 
A = A(1:subSampleStep:end,:);
covA = covA(1:subSampleStep:end,:,:);
B = B(1:subSampleStep:end,:);
covB = covB(1:subSampleStep:end,:,:);

%%
clc
init;
subSampleStep = 10
nbNeighbors = 20;
[A,covA,poseA] = loadDBData('data/hannover1/scan000',nbNeighbors);
[B,covB,poseB] = loadDBData('data/hannover1/scan004',nbNeighbors);

gtTransform(1) = poseA(2,1)-poseB(2,1);
gtTransform(2) = poseA(2,2)-poseB(2,2);
gtTransform(3) = poseA(2,3)-poseB(2,3);
gtTransform(4) = poseA(1,1)-poseB(1,1);
gtTransform(5) = poseA(1,2)-poseB(1,2);
gtTransform(6) = poseA(1,3)-poseB(1,3);

clear poseA;
clear poseB;

%Subsample 
A = A(1:subSampleStep:end,:);
covA = covA(1:subSampleStep:end,:,:);
B = B(1:subSampleStep:end,:);
covB = covB(1:subSampleStep:end,:,:);



initTransform = gtTransform;

initTransform(1:3) = degtorad(initTransform(1:3))
initTransform(1) = initTransform(1)+degtorad(5);
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(3) = initTransform(3)-degtorad(10);
initTransform(4) = initTransform(4)+0.1;
initTransform(5) = initTransform(5)-0.1;
initTransform(6) = initTransform(6);

initTransform


%%

close all;
clf;
[A_trans,transformation_evolution,size_subset] = minimization(A,covA,B,covB,gtTransform,initTransform,20,0.1,true);
%[A_trans evol_transform,size_subset]= ICP_ClosedForm(A,B,initTransform,150,0.1);
computeAverageErrorWithNN(A_trans,B)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test d'average error sur nuages de points similaires
clc
init;
subSampleStep = 10
nbNeighbors = 20;
[A,covA,poseA] = loadDBData('data/hannover1/scan000',nbNeighbors);

A = A(1:subSampleStep:end,:);
covA = covA(1:subSampleStep:end,:,:);

gtTransform = zeros(1,6);

initTransform = gtTransform;

initTransform(1:3) = degtorad(initTransform(1:3))
initTransform(1) = initTransform(1)+degtorad(5);
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(3) = initTransform(3)-degtorad(10);
initTransform(4) = initTransform(4)+20;
initTransform(5) = initTransform(5)-15;
initTransform(6) = initTransform(6)+10;

close all;
clf;
[A_trans,transformation_evolution,size_subset] = minimization(A,covA,A,covA,gtTransform,initTransform,50,1000,true);


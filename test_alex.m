init;

nbNeighbors = 15;
gtTransform = [-10,10,3,0.1,-0.05,0.03]
%A is a bunny
%B is the A bunny that was subject to a rotation and a translation
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);                       
%Subsample 
A = A(1:10:end,:);
covA = covA(1:10:end,:,:);
B = B(1:10:end,:);
covB = covB(1:10:end,:,:);

%%
clc
init;

nbNeighbors = 20
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
A = A(1:5:end,:);
covA = covA(1:5:end,:,:);
B = B(1:5:end,:);
covB = covB(1:5:end,:,:);



%%
close all;
clf;

initTransform = gtTransform;

initTransform(1:3) = degtorad(initTransform(1:3))
initTransform(1) = initTransform(1)+degtorad(5);
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(3) = initTransform(3)-degtorad(10);
initTransform(4) = -initTransform(4)+20;
initTransform(5) = -initTransform(5)+50;
initTransform(6) = initTransform(6)-30;



[A_trans,transformation_evolution] = minimization(A,covA,B,covB,gtTransform,initTransform,20,500,true);
%A_trans = ICP_ClosedForm(A,B,initTransform,100,300);


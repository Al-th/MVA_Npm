%%
clear;
clc;
init;

disp('Computing sICP on the bunny dataset');

subSampleStep = 20;
nbNeighbors = 20;
gtTransform = [-10,10,3,0.1,-0.05,0.03];

disp('Loading data');
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);  

disp('Subsampling data');
A = A(1:subSampleStep:end,:);
covA = covA(1:subSampleStep:end,:,:);
B = B(1:subSampleStep:end,:);
covB = covB(1:subSampleStep:end,:,:);

disp('Give an initial guess of the transformation')
initTransform = gtTransform;

initTransform(1:3) = degtorad(initTransform(1:3));
initTransform(1) = initTransform(1)+degtorad(5);
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(3) = initTransform(3)-degtorad(10);
initTransform(4) = initTransform(4)+0.1;
initTransform(5) = initTransform(5)-0.1;
initTransform(6) = initTransform(6);

disp('Initial guess is :')
[radtodeg(initTransform(1:3)) initTransform(4:6)]

%%
disp('Computing transform with sICP');
[A_trans_SICP,transformation_evolution_SICP,size_subset_SICP,error_pos_SICP] = minimization(A,covA,B,covB,gtTransform,initTransform,30,0.1,false);

%%
disp('Computing transform with gICP');
[A_trans_GICP,transformation_evolution_GICP,size_subset_GICP,error_pos_GICP] = minimization(A,covA,B,covB,gtTransform,initTransform,30,0.1,true);

%%
disp('Computing transform with closed-form ICP');
[A_trans_Closedform, evol_transform_Closedform ,size_subset_Closedform]= ICP_closedForm(A,B,initTransform,150,0.1);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
init;

disp('Computing sICP on the hannovr dataset');

subSampleStep = 10
nbNeighbors = 20;
gtTransform = [-10,10,3,0.1,-0.05,0.03];

disp('Loading data');
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

disp('Subsampling data');
A = A(1:subSampleStep:end,:);
covA = covA(1:subSampleStep:end,:,:);
B = B(1:subSampleStep:end,:);
covB = covB(1:subSampleStep:end,:,:);

disp('Give an initial guess of the transformation')
initTransform = gtTransform;

initTransform(1:3) = degtorad(initTransform(1:3));
initTransform(1) = initTransform(1)+degtorad(5);
initTransform(2) = initTransform(2)-degtorad(15);
initTransform(3) = initTransform(3)-degtorad(10);
initTransform(4) = -initTransform(4)+20;
initTransform(5) = initTransform(5)-10;
initTransform(6) = initTransform(6)+15;

disp('Initial guess is :')
[radtodeg(initTransform(1:3)) initTransform(4:6)]

%%
disp('Computing transform with sICP');
[A_trans_SICP,transformation_evolution_SICP,size_subset_SICP, error_pos_SICP] = minimization(A,covA,B,covB,gtTransform,initTransform,30,200,false);

%%
disp('Computing transform with gICP');
[A_trans_GICP,transformation_evolution_GICP,size_subset_GICP, error_pos_GICP] = minimization(A,covA,B,covB,gtTransform,initTransform,30,200,true);


%%
disp('Computing transform with closed-form ICP');
[A_trans_Closedform, evol_transform_Closedform ,size_subset_Closedform]= ICP_closedForm(A,B,initTransform,150,200);

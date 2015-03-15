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
[A,covA,poseA] = loadDBData('data/hannover1/scan000',nbNeighbors);
[B,covB,poseB] = loadDBData('data/hannover1/scan004',nbNeighbors);

gtTransform(1) = poseB(1)-poseA(1)
gtTransform(2) = poseB(2)-poseA(2)
gtTransform(3) = poseB(3)-poseA(3)
gtTransform(4) = poseB(4)-poseA(4)
gtTransform(5) = poseB(5)-poseA(5)
gtTransform(6) = poseB(6)-poseA(6)

%Subsample 
A = A(1:10:end,:);
covA = covA(1:10:end,:,:);
B = B(1:10:end,:);
covB = covB(1:10:end,:,:);



%%
[A_trans,transformation] = minimization(A,covA,B,covB,gtTransform,50,1000);
%A_trans = ICP_ClosedForm(A,B);


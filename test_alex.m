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
[A_trans,transformation] = minimization(A,covA,B,covB,gtTransform);
%A_trans = ICP_ClosedForm(A,B);


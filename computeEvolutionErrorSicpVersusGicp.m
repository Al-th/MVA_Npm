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
initTransform(4) = -initTransform(4)+20;
initTransform(5) = initTransform(5)-10;
initTransform(6) = initTransform(6)+15;


%%

clc

for j = 1:8

fileNameGicp = ['./Test/info_dmax_hannover_gicp' int2str(j) '.mat'];
tempInfoGicp = load(fileNameGicp);
tempInfoGicp = tempInfoGicp.info_gicp{end};

fileNameSicp = ['./Test/info_dmax_hannover_sicp' int2str(j) '.mat'];
tempInfoSicp = load(fileNameSicp);
tempInfoSicp = tempInfoSicp.info_sicp{end};

nGicp =[];
nSicp =[];
for i = 1:size(tempInfoGicp.evolution_transformation,1)
    transform = tempInfoGicp.evolution_transformation(i,:);
    A_trans = transformPointCloud(A,transform);
    err = computeAverageErrorWithNN(B,A_trans);
    nGicp = [nGicp err];
end

for i = 1:size(tempInfoSicp.evolution_transformation,1)
    transform = tempInfoSicp.evolution_transformation(i,:);
    A_trans = transformPointCloud(A,transform);
    err = computeAverageErrorWithNN(B,A_trans);
    nSicp = [nSicp err];
end

plot(nGicp,'b');
hold on
plot(nSicp,'r');
hold off;
legend('Generalized ICP','Standard ICP');
xlabel('Iteration');
ylabel('Average Error (cm)');
title(sprintf('Hannover scans (1373 points), dmax : %d',tempInfoGicp.dMax));
pause()
end

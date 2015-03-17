clear all;
clc;

subsampling = 20;

nbNeighbors = 20;
gtTransform = [-10,0,0,0.1,-0.2,0.1];
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);
initTransform = gtTransform;
initTransform(1:3) = degtorad(initTransform(1:3));
initTransform(1) = initTransform(1)-degtorad(5);
initTransform(2) = initTransform(2)+degtorad(5);
initTransform(3) = initTransform(3);
initTransform(4) = initTransform(4)+0.1;
initTransform(5) = initTransform(5)-0.1;
initTransform(6) = initTransform(6);
%Subsample 
A = A(1:subsampling:end,:);
covA = covA(1:subsampling:end,:,:);
B = B(1:subsampling:end,:);
covB = covB(1:subsampling:end,:,:);

%%
Rx = [20:5:65];

n_gicp = [];
for j = 1:size(Rx,2)
    fileNameRx = ['./Test/info_Rx_bunny_gicp_-' int2str(Rx(j)) '.0.mat'];
    tempInfoRx = load(fileNameRx);
    tempInfoRx = tempInfoRx.info_gicp;
    nGicp =[];
    
    for i = 1:size(tempInfoRx.evolution_transformation,1)
        transform = tempInfoRx.evolution_transformation(i,:);
        A_trans = transformPointCloud(A,transform);
        err = computeAverageErrorWithNN(B,A_trans);
        nGicp = [nGicp err];
    end
    n_gicp = [n_gicp nGicp(end)];
    plot(nGicp)
    pause();
end

%%
figure(1);
hold on;
plot(Rx,n_gicp,'r','LineWidth',2);
hold off;
%axis([0 2000 40 70]);
xlabel('Rotation along x-axis (degre)');
ylabel('Average error (cm)');
title('Bunny scans (1529 points)');
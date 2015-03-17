%%Test A effectuer
clear; clc;
init;

subsampling = 20;

%Test on Bunny
disp('Process on Bunny.asc - Test offset - SICP');
%Initialization for Bunny
nbNeighbors = 20;
gtTransform = [-10,0,0,0.1,-0.2,0.1];
[A,covA,B,covB] = setupData(gtTransform(1),gtTransform(2),gtTransform(3),...
                            gtTransform(4),gtTransform(5),gtTransform(6),...
                            nbNeighbors);
                        
%Subsample 
A = A(1:subsampling:end,:);
covA = covA(1:subsampling:end,:,:);
B = B(1:subsampling:end,:);
covB = covB(1:subsampling:end,:,:);
%%
initTransform = gtTransform;
initTransform(1:3) = degtorad(initTransform(1:3));
initTransform(1) = initTransform(1)-degtorad(5);
initTransform(2) = initTransform(2)+degtorad(5);
initTransform(3) = initTransform(3);
initTransform(4) = initTransform(4)+0.1;
initTransform(5) = initTransform(5)-0.1;
initTransform(6) = initTransform(6);
%%
%Define number of Rx to test
nb_Rx = 10;
step_Rx = 5;

dMax = 0.1;
iterMax = [150 50];
%Define param to store results
info_sicp = {};

for i = 1:5
    initTransform(1) = initTransform(1)-degtorad(5);
end

radtodeg(initTransform(1))

%%
for i = 6:nb_Rx
    initTransform(1) = initTransform(1)-degtorad(5);
    fprintf('### Rx : %d, number %d/%d###\n',radtodeg(initTransform(1)),i,nb_Rx);
    tic
    [A_trans,evol_T,size_subset] = minimization(A,covA,B,covB,...
                                              gtTransform, initTransform,... 
                                              iterMax(2),dMax,false);
    elapsed_time = toc;    
    info_sicp.Rx = radtodeg(initTransform(1));
    info_sicp.time = elapsed_time;
    info_sicp.average_error = norm(B-A_trans,2);
    info_sicp.evolution_transformation = evol_T;
    info_sicp.size_subset = size_subset;
    %info_sicp{i}.estimate_transformation = transformation;                        
    fprintf('time : %.2f, err : %.2d ,converge in %f iterations. \n',...
        elapsed_time, info_sicp.average_error ,size(size_subset,2));    
    save(sprintf('./Test/info_Rx_bunny_sicp_%-4.1f.mat',radtodeg(initTransform(1))),'info_sicp');
 
end
disp('Test differents value for Rx done');

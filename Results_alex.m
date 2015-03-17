clc;
clear;

info_sicp = load('Test/info_dmax_hannover_sicp8.mat');
gt = load('data/hannover1/scan004.pose');
gt = -[gt(2,1) gt(2,2) gt(2,3) gt(1,1) gt(1,2) gt(1,3)]
info_sicp = info_sicp.info_sicp;

info_gicp = load('Test/info_dmax_hannover_gicp8.mat');
gt = load('data/hannover1/scan004.pose');
gt = -[gt(2,1) gt(2,2) gt(2,3) gt(1,1) gt(1,2) gt(1,3)]
info_gicp = info_gicp.info_gicp;

sicp_err = [];
gicp_err = [];
for i = 1:8
    evol = info_sicp{i}.evolution_transformation;
    evol(:,1:3) = radtodeg(evol(:,1:3));

    
    figure(1);
    plot(evol(:,1)-gt(1),'r');
    hold on;
    plot(evol(:,2)-gt(2),'r');
    plot(evol(:,3)-gt(3),'r');
    hold off;
    
    figure(2);
    plot(-evol(:,4)-gt(4),'r');
    hold on;
    plot(evol(:,5)-gt(5),'r');
    plot(evol(:,6)-gt(6),'r');
    hold off;


    evol = info_gicp{i}.evolution_transformation;
    evol(:,1:3) = radtodeg(evol(:,1:3));
    
    
    figure(1);
    hold on;
    plot(evol(:,1)-gt(1),'b-');
    plot(evol(:,2)-gt(2),'b-');
    plot(evol(:,3)-gt(3),'b-');
    hold off;
    
    figure(2);
    hold on;
    plot(-evol(:,4)-gt(4),'b-');
    plot(evol(:,5)-gt(5),'b-');
    plot(evol(:,6)-gt(6),'b-');
    hold off;
    
    pause()
    
    sicp_err = [sicp_err info_sicp{i}.average_error];
    gicp_err = [gicp_err info_gicp{i}.average_error];
 
end

figure(3);
plot(sicp_err,'r')
hold on;
plot(gicp_err,'b')
hold off;


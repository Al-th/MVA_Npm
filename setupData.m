function [A,covA,B,covB] = setupData(degX,degY,degZ,Tx,Ty,Tz,nbNeighbors)


    %Load bunny
    %Use rotation and translation to compute new bunny
    
    bunny = load('bunny.asc');

    theta_x = degtorad(degX);
    theta_y = degtorad(degY);
    theta_z = degtorad(degZ);
    
    
    bunny_transRota = transformPointCloud(bunny,[theta_x,theta_y,theta_z,Tx,Ty,Tz]);

    bunny_transRota = bunny_transRota; %+ randn(size(bunny,1),3)/1000;

    A = bunny;
    B = bunny_transRota;
    
    covA = getCov(A, nbNeighbors);  
    covB = getCov(B, nbNeighbors);
    
    
end
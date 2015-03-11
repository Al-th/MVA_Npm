function [A,B] = setupData(degX,degY,degZ,Tx,Ty,Tz)
    %Load bunny
    %Use rotation and translation to compute new bunny
    
    bunny = load('bunny.asc');
    
    bunny = bunny(1:10:end,:);
    
    
    theta_x = deg2rad(degX);
    theta_y = deg2rad(degY);
    theta_z = deg2rad(degZ);
    
    
    bunny_transRota = transformPointCloud(bunny,[theta_x,theta_y,theta_z,Tx,Ty,Tz]);

    bunny_transRota = bunny_transRota + randn(size(bunny,1),3)/1000;

    A = bunny;
    B = bunny_transRota;
end
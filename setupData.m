function [A,B] = setupData(degX,degY,degZ,Tx,Ty,Tz)
    %Load bunny
    %Use rotation and translation to compute new bunny
    
    bunny = load('bunny.asc');
    
    bunny = bunny(1:10:end,:);

    theta_x = deg2rad(degX);
    theta_y = deg2rad(degY);
    theta_z = deg2rad(degZ);

    Rx = [1 0 0 ; 0 cos(theta_x) -sin(theta_x); 0 sin(theta_x) cos(theta_x)];
    Ry = [cos(theta_y) 0 sin(theta_y); 0 1 0; -sin(theta_y) 0 cos(theta_y)];
    Rz = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 1];

    T = [Tx;Ty;Tz];

    bunny_transRota = (Rx*Ry*Rz)*bunny';
    bunny_transRota = bunny_transRota' + repmat(T',size(bunny,1),1);

    bunny_transRota = bunny_transRota + randn(size(bunny,1),3)/1000;

    A = bunny;
    B = bunny_transRota;
end
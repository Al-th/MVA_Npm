function [A,B] = setupData(degX,degY,degZ,Tx,Ty,Tz)
    %Load bunny
    %Use rotation and translation to compute new bunny
    
    bunny = load('bunny.asc');
    
    
    bunny = bunny(1:10:end,:);
    size_bunny = size(bunny,1);
    
    theta_x = degtorad(degX);
    theta_y = degtorad(degY);
    theta_z = degtorad(degZ);

    Rx = [1 0 0 ; 0 cos(theta_x) -sin(theta_x); 0 sin(theta_x) cos(theta_x)];
    Ry = [cos(theta_y) 0 sin(theta_y); 0 1 0; -sin(theta_y) 0 cos(theta_y)];
    Rz = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 1];

    T = [Tx;Ty;Tz];

    bunny_transRota = (Rx*Ry*Rz)*bunny';
    bunny_transRota = bunny_transRota' + repmat(T',size_bunny,1);

    bunny_transRota = bunny_transRota + randn(size_bunny,3)/1000;

    A = bunny;
    B = bunny_transRota;
end
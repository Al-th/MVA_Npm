function M = computeTransformationMatrixFromParams(params)

gamma = params(1);
beta = params(2);
alpha = params(3);
Tx = params(4);
Ty = params(5);
Tz = params(6);


%Compute rotation and translation matrices
calpha = cos(alpha);
salpha = sin(alpha);
cbeta = cos(beta);
sbeta = sin(beta);
cgamma = cos(gamma);
sgamma = sin(gamma);


R = [calpha*cbeta, calpha*sbeta*sgamma-salpha*cgamma, calpha*sbeta*cgamma+salpha*sgamma; ...
    salpha*cbeta, salpha*sbeta*sgamma+calpha*cgamma, salpha*sbeta*cgamma-calpha*sgamma; ...
    -sbeta, cbeta*sgamma, cbeta*cgamma];

T = [Tx;Ty;Tz];

%Homogeneous 3D rigid transformation
M = [R,T];
M = [M; 0 0 0 1];

end
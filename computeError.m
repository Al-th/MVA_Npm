function atomicError = computeError(transformation,p1 ,cov1 ,p2 ,cov2)
%Get the parameters
alpha = transformation(1);
beta = transformation(2);
gamma = transformation(3);
Tx = transformation(4)
Ty = transformation(5);
Tz = transformation(6);

%Transform a and b to homogeneous coordinates for further calculation
a = [p1';1];
b = [p2';1];

%Reshape covariance matrices
Ca = reshape(cov1,3,3)';
Cb = reshape(cov2,3,3)';

%Compute rotation and translation matrixmatrix
calpha = cos(alpha); salpha = sin(alpha);
cbeta = cos(beta); sbeta = sin(beta);
cgamma = cos(gamma); sgamma = sin(gamma);

R = [calpha*cbeta, calpha*sbeta*sgamma-salpha*cgamma, calpha*sbeta*cgamma+salpha*sgamma; ...
    salpha*cbeta, salpha*sbeta*sgamma+calpha*cgamma, salpha*sbeta*cgamma-calpha*sgamma; ...
    -sbeta, cbeta*sgamma, cbeta*cgamma];

T = [Tx;Ty;Tz];

%Homogeneous 3D rigid transformation
Tr = [R];
Tr = [R,T];
Tr = [Tr; 0 0 0 1];

d = (b-Tr*a)

mid = Cb + R*Ca*R';
invMid = inv(mid);

%remove homogeneous coordinate of d

d = d(1:end-1));
atomicError = d'*invMid*d;


end
init;

%A is a bunny
%B is the A bunny that was subject to a rotation and a translation
[A,B] = setupData(0,0,0,0.1,0.2,-0.1);

[A_trans] = minimization(A,B);
init;

%A is a bunny
%B is the A bunny that was subject to a rotation and a translation
[A,B] = setupData(10,7,3,0.1,0,-0.1);

[A_trans,transformation] = minimization(A,B);
%A_trans = ICP_ClosedForm(A,B);
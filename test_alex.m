init;

%A is a bunny
%B is the A bunny that was subject to a rotation and a translation
[A,B] = setupData(20,0,0,0,0,0);

[A_trans,transformation] = minimization(A,B);
%A_trans = ICP_ClosedForm(A,B);


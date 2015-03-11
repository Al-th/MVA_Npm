clear all;
clc;

syms R11 R12 R13 R21 R22 R23 R31 R32 R33;

syms Tx Ty Tz;

calpha = cos(alpha); salpha = sin(alpha);
cbeta = cos(beta); sbeta = sin(beta);
cgamma= cos(gamma); sgamma = sin(gamma);

T = [calpha*cbeta, calpha*sbeta*sgamma-salpha*cgamma, calpha*sbeta*cgamma+salpha*sgamma; ...
    salpha*cbeta, salpha*sbeta*sgamma+calpha*cgamma, salpha*sbeta*cgamma-calpha*sgamma; ...
    -sbeta, cbeta*sgamma, cbeta*cgamma];
    ];
R = [R11 R12 R13; R21 R22 R23; R31 R32 R33]
T = [z
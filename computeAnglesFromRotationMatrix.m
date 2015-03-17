function [alpha,beta,gamma] = computeAnglesFromRotationMatrix(R)
    beta = asin(-R(3,1));
    alpha = atan(R(2,1)/R(1,1));
    gamma = atan(R(3,2)/R(3,3));
end
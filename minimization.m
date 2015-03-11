path(path, 'kdtree');

nbNeighbors = 20;
iterMax = 250;

% A n*3
% B n*3

tic
covA = getCov(A, nbNeighbors);
covB = getCov(B, nbNeighbors);
toc
%%
transformation0 = eye(4,4);
transformation = transformation0;
for i = 1:iterMax
    %Find the closest point b <=> T*ai
    % idx t.q A = B(idx);
    tree = kdtree_build(B);
    closestPointIndex = zeros(size(A,1),1);
    for j = 1:size(A,1)
        homogeneousCoord = [A(i,:)';1];
        transformedPoint = transformation*homogeneousCoord;
        transformedPoint = transformedPoint(1:3);
        idx = kdtree_k_nearest_neighbors(tree,transformedPoint,1);
        closestPointIndex(j) = idx;
    end
    
    %Remove from set points that are too far
    % if abs(A - B(idx)) < dMax : on garde
    % fill the param (points, normals, covar);
    param{1}.point = zeros(size(A,1),size(A,2));
    param{1}.cov = zeros(size(A,1),9);
    
    param{2}.point = zeros(size(B,1),size(B,2));
    param{2}.cov = zeros(size(A,1),9);
    
    nbSubset = 0;
    for j = 1:size(A,1)
        distanceBetweenPair = norm(A-transformation*B(closestPointIndex(j)),2);
        if(distanceBetweenPair < dMax)
           nbSubset = nbSubset + 1;
           param{1}.point(i,:) = A(i,:);
           param{2}.point(i,:) = B(i,:);
           
           param{1}.cov = covA(i,:);
           param{2}.cov = covB(i,:);
        end
    end
    % Reduce param to subset only
    param{1}.point = param{1}.point(1:nbSubset,:);
    param{2}.point = param{2}.point(1:nbSubset,:);
    param{1}.cov = param{1}.cov(1:nbSubset,:);
    param{2}.cov = param{2}.cov(1:nbSubset,:);
    
    f = @(x)costFunction(x,param);
    
    [transformation, cost] = fminunc(f,transformation);
    
end
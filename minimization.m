function [A_trans] = minimization(A,B)
    nbNeighbors = 20;
    iterMax = 250;
    dMax = 20;


    tic
    covA = getCov(A, nbNeighbors);
    covB = getCov(B, nbNeighbors);
    toc

    function [cost] = costFunction(transformation, param)
        cost = 0;
        for pairIndex = 1:size(param{1}.point,1)
           cost = cost + computeError(transformation, ...
               param{1}.point(pairIndex,:), squeeze(param{1}.cov(pairIndex,:,:)), ...
               param{2}.point(pairIndex,:), squeeze(param{2}.cov(pairIndex,:,:))...
               ); 
        end
    end

    tree = kdtree_build(B);

    transformation0 = zeros(6,1);
    transformation = transformation0;


    for i = 1:iterMax
        A_trans = transformPointCloud(A,transformation);


        %Find the closest point b <=> T*ai
        % idx t.q A = B(idx);
        closestPointIndex = zeros(size(A,1),1);
        for j = 1:size(A,1)
            closestPointIndexInB(j) = kdtree_k_nearest_neighbors(tree,A_trans(j,:),1);;
        end

        %Remove from set points that are too far
        % if abs(A - B(idx)) < dMax : on garde
        % fill the param (points, normals, covar);
        param{1}.point = zeros(size(A,1),size(A,2));
        param{1}.cov = zeros(size(A,1),3,3);
        param{2}.point = zeros(size(B,1),size(B,2));
        param{2}.cov = zeros(size(A,1),3,3);

        nbSubset = 0;
        for j = 1:size(A,1)
            distanceBetweenPair = norm(A_trans(j,:) - B(closestPointIndexInB(j),:),2);
            if(distanceBetweenPair < dMax)
               nbSubset = nbSubset + 1;
               param{1}.point(nbSubset,:) = A_trans(j,:);
               param{2}.point(nbSubset,:) = B(closestPointIndexInB(j),:);

               param{1}.cov(nbSubset,:,:) = covA(j,:,:);
               param{2}.cov(nbSubset,:,:) = covB(closestPointIndexInB(j),:,:);
            end
        end
        nbSubset
        % Reduce param to subset only
        param{1}.point = param{1}.point(1:nbSubset,:);
        param{2}.point = param{2}.point(1:nbSubset,:);
        param{1}.cov = param{1}.cov(1:nbSubset,:,:);
        param{2}.cov = param{2}.cov(1:nbSubset,:,:);

        
        [transformation, ~] = fminsearch(@costFunction,transformation,struct('Display', 'iter', 'TolFun',1e-3,'TolX',0.1),param);
    end
    
end
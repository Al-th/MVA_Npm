
function [A_trans, transformation_evolution, size_subset] = minimization(A,covA,B,covB,groundTruthTransformation,initTransform,iterMax,dMax,useGenICP)

   
    transformation = initTransform;
    transformation_evolution = [transformation];
    size_subset = [];
        
    tree = kdtree_build(B);

    %Precompute covariance matrices for each point in the point clouds

    
    %Define a cost function that is the sum of the atomic error of each
    %pair of points
    function [cost] = costFunction(transformation, param)
        cost = 0;
        for pairIndex = 1:size(param{1}.point,1)
           cost = cost + computeError(transformation, ...
               param{1}.point(pairIndex,:), squeeze(param{1}.cov(pairIndex,:,:)), ...
               param{2}.point(pairIndex,:), squeeze(param{2}.cov(pairIndex,:,:)),...
               useGenICP); 
        end
    end

    %Set up the initial transformation

    eps = 10000.0;
    lastDist = 10000;
    fprintf('epsilon ');
    for i = 1:iterMax
        fprintf('%.2d ',eps);
        if (abs(eps) < 5e-5)
            break
        end
        
        if i > 1
            diffTransform = transformation_evolution(end,:)-transformation_evolution(end-1,:)
            if (abs(diffTransform(1))<0.1 && ...
                    abs(diffTransform(2))<0.1 && ...
                    abs(diffTransform(3))<0.1 && ...
                    abs(diffTransform(4))<0.001 && ...
                    abs(diffTransform(5))<0.001 && ...
                    abs(diffTransform(6))<0.001)
               break 
            end
        end
        
        A_trans = transformPointCloud(A,transformation);
        
        figure(1);
        step = 1;
        ind = [1:step:size(B,1)];
        scatter3(B(ind,1),B(ind,2),B(ind,3),15,'o','filled');
        hold on
        ind = [1:step:size(A_trans,1)];
        scatter3(A_trans(ind,1),A_trans(ind,2),A_trans(ind,3),15,'o','filled');
        hold off;
        pause(0.01);



        %Find the closest point of T*ai in the space spanned by B
        closestPointIndexInB = zeros(size(A_trans,1),1);
        for j = 1:size(A,1)
            closestPointIndexInB(j) = kdtree_k_nearest_neighbors(tree,A_trans(j,:),1);
        end

        
        %Remove from set points that are too far
        % if abs(A - B(idx)) < dMax : on garde
        % fill the param (points, normals, covar);
        param{1}.point = zeros(size(A,1),size(A,2));
        param{1}.cov = zeros(size(A,1),3,3);
        param{2}.point = zeros(size(B,1),size(B,2));
        param{2}.cov = zeros(size(B,1),3,3);

        nbSubset = 0;
        for j = 1:size(A,1)
            distanceBetweenPair = norm(A_trans(j,:) - B(closestPointIndexInB(j),:),2);
            if(distanceBetweenPair < dMax)
               nbSubset = nbSubset + 1;
               param{1}.point(nbSubset,:) = A(j,:);
               param{2}.point(nbSubset,:) = B(closestPointIndexInB(j),:);

               param{1}.cov(nbSubset,:,:) = covA(j,:,:);
               param{2}.cov(nbSubset,:,:) = covB(closestPointIndexInB(j),:,:);
            end
        end
        size_subset = [size_subset nbSubset];
        % Reduce param to subset only
        param{1}.point = param{1}.point(1:nbSubset,:);
        param{2}.point = param{2}.point(1:nbSubset,:);
        param{1}.cov = param{1}.cov(1:nbSubset,:,:);
        param{2}.cov = param{2}.cov(1:nbSubset,:,:);

        f = @(x)costFunction(x,param);
  
        [transformation, dist] = fminunc(f,transformation,struct('Display', 'final', 'LargeScale','off','TolFun',1e-6,'TolX',1e-10));
        eps = lastDist - dist;
        lastDist = dist;
        
         figure(2);
         hold on;
         plot(i,radtodeg(transformation(1))-groundTruthTransformation(1),'ro');
         plot(i,radtodeg(transformation(2))-groundTruthTransformation(2),'go');
         plot(i,radtodeg(transformation(3))-groundTruthTransformation(3),'bo');
         hold off;
         
         figure(3);
         hold on;
         plot(i,transformation(4)-groundTruthTransformation(4),'ro');
         plot(i,transformation(5)-groundTruthTransformation(5),'go');
         plot(i,transformation(6)-groundTruthTransformation(6),'bo');
         hold off;

        

        [radtodeg(transformation(1:3)) transformation(4:6)]

        
        transformation_evolution = [transformation_evolution; transformation];
    end
    fprintf('\n');
    
end
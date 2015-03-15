function current = ICP_closedForm(A,B,initTransform,iterMax,dMax)

A = transformPointCloud(A,initTransform);
tree = kdtree_build(B);
current = A;

for i = 1:iterMax
    
    step = 1;
    ind = [1:step:size(B,1)];
    scatter3(B(ind,1),B(ind,2),B(ind,3),15,'o','filled');
    hold on
    ind = [1:step:size(current,1)];
    scatter3(current(ind,1),current(ind,2),current(ind,3),15,'o','filled');
    hold off;
    pause(0.1);
    
    
    %Find the closest point of T*ai in the space spanned by B
    closestPointIndexInB = zeros(size(current,1),1);
    for j = 1:size(A,1)
        closestPointIndexInB(j) = kdtree_k_nearest_neighbors(tree,current(j,:),1);
    end


    %Remove from set points that are too far
    % if abs(A - B(idx)) < dMax : on garde
    % fill the param (points, normals, covar);
    param{1}.point = zeros(size(current,1),size(current,2));
    param{2}.point = zeros(size(B,1),size(B,2));

    nbSubset = 0;
    for j = 1:size(A,1)
        distanceBetweenPair = norm(current(j,:) - B(closestPointIndexInB(j),:),2);
        if(distanceBetweenPair < dMax)
            nbSubset = nbSubset + 1;
            param{1}.point(nbSubset,:) = current(j,:);
            param{2}.point(nbSubset,:) = B(closestPointIndexInB(j),:);
        end
    end
    nbSubset
    % Reduce param to subset only
    param{1}.point = param{1}.point(1:nbSubset,:);
    param{2}.point = param{2}.point(1:nbSubset,:);
    
    
    b = zeros(1,3);
    bp = zeros(1,3);
    for i = 1:size(param{1}.point,1)
        b = b+param{1}.point(i,:);
        bp = bp+param{2}.point(i,:);
    end
    b = b/size(param{1}.point,1);
    bp = bp/size(param{2}.point,1);

    H = zeros(3,3);
    for i = 1:size(param{1}.point,1)
       H = H+(param{2}.point(i,:)-bp)'*(param{1}.point(i,:)-b); 
    end

    [U,S,V] = svd(H);

    R_est = V*U';
    t_est = b' - R_est*bp';
    
    current = (R_est'*current')' - repmat(t_est',size(current,1),1);
    
end
end
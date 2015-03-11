function reshapedCov = getCov(pointCloud,nbNeighbors)
    epsilon = 1e-5;
    treeInitPointCloud = kdtree_build(pointCloud);
    reshapedCov = zeros(size(pointCloud,1),9);
    
    for i = 1:size(pointCloud,1)
        if(mod(i,1000)==0)
           i 
        end
        idxs = kdtree_k_nearest_neighbors(treeInitPointCloud,pointCloud(i,:),nbNeighbors);

        barycenter = (1/size(idxs,1))*sum(pointCloud(idxs,:));
        covMat = zeros(3,3);
        for j = 1:size(idxs,1)
            covMat = covMat + ((pointCloud(j,:)-barycenter)'*(pointCloud(j,:)-barycenter));
        end
        covMat = (1/size(idxs,1))*covMat;

        [U,~,~] = svd(covMat);
        S = diag([epsilon,1,1]);

        reformedCov = U*S*U';
        reshapedCov(i,:) = reshape(reformedCov',1,9);
    end
end
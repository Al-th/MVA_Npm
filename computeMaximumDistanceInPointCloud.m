function maxDistance = computeMaximumDistanceInPointCloud(pointCloud)
    A = pointCloud;
    tree = kdtree_build(A);

    distMax = 0;
    j=0;
    for i = 1:size(A,1)
       nnIdx = kdtree_k_nearest_neighbors(tree, A(i,:), size(A,1));
       dist = norm(A(nnIdx(1),:)-A(i,:));
       if(dist>distMax)
           distMax = dist
           plot(j,distMax,'o');
           j=j+1;
           hold on;
           pause(0.1);
       end
    end

end
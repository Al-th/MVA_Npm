function average_error = computeAverageErrorWithNN(pc1, pc2)
if( size(pc1,1) < size(pc2,1) )
    A = pc1;
    B = pc2;
else 
    A = pc2;
    B = pc1; 
end

tree = kdtree_build(B);
average_error = 0;

for j = 1:size(A,1)
  closestPointIndexInB = kdtree_k_nearest_neighbors(tree,A(j,:),1);
  distanceBetweenPair = norm(A(j,:) - B(closestPointIndexInB,:),2);
  average_error = average_error + distanceBetweenPair;
end
average_error = average_error/size(A,1);

end


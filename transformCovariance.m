function covMat_Trans = transformCovariance(covMat,M)
    covMat_Trans = zeros(size(covMat,1),size(covMat,2));
    for i = 1:size(covMat,1)
       c = M(1:3,1:3)*reshape(covMat(i,:),3,3)'*M(1:3,1:3)'; 
       covMat_Trans(i,:) = reshape(c',1,9);
    end
end
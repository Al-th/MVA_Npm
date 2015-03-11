function pc_Trans= transformPointCloud(pc, params)   

    M = computeTransformationMatrixFromParams(params);
    
    pc = [pc, ones(size(pc,1),1)];
    pc_Trans = (M*pc')';
    pc_Trans = pc_Trans(:,1:3);
 
end
function [cost] = costFunction(transformation, param)
    cost = 0;

    for i = 1:size(param{1}.point,1)
       cost = cost + computeError(transformation, ...
           param{1}.point(i,:), param{1}.cov(i,:), ...
           param{2}.point(i,:), param{2}.cov(i,:)...
           ); 
    end
    
    
end
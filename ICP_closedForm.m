function A_Trans = ICP_closedForm(A,B)
objective = B;
current = A;
distanceThreshold = 1;

for i = 1:10
    step = 10;
    ind = [1:step:size(A,1)];
    scatter3(objective(ind,1),objective(ind,2),objective(ind,3),15,'o','filled');
    hold on
    scatter3(current(ind,1),current(ind,2),current(ind,3),15,'o','filled');
    hold off;
    pause();
    currentTrimmed =[];
    objectiveTrimmed = [];
    distance = current-objective;
    nbValidPoints = 0;
    currentTrimmed = zeros(size(current,1),size(current,2));
    objectiveTrimmed = zeros(size(objective,1),size(objective,2));
    for i = 1:size(current,1)
       pointDistance = norm(distance(i,:)); 
       if (pointDistance < distanceThreshold)
        nbValidPoints = nbValidPoints +1;
        currentTrimmed(nbValidPoints,:) = current(i,:);
        objectiveTrimmed(nbValidPoints,:) = objective(i,:);
       end
    end
    currentTrimmed = currentTrimmed(1:nbValidPoints,:);
    objectiveTrimmed = objectiveTrimmed(1:nbValidPoints,:);
    nbValidPoints
    b = zeros(1,3);
    bp = zeros(1,3);
    for i = 1:size(currentTrimmed,1)
        b = b+currentTrimmed(i,:);
        bp = bp+objectiveTrimmed(i,:);
    end
    b = b/size(currentTrimmed,1);
    bp = bp/size(objectiveTrimmed,1);

    H = zeros(3,3);
    for i = 1:size(currentTrimmed,1)
       H = H+(objectiveTrimmed(i,:)-bp)'*(currentTrimmed(i,:)-b); 
    end

    [U,S,V] = svd(H);

    R_est = V*U';
    t_est = b' - R_est*bp';
    
    current = (R_est'*current')' - repmat(t_est',size(current,1),1);
    
end
A_trans = current
end
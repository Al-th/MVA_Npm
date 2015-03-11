clear;
clc;
bunny = load('bunny.asc');

%%

theta_x = degtorad(23.5);
theta_y = degtorad(19.83);
theta_z = degtorad(70);

Rx = [1 0 0 ; 0 cos(theta_x) -sin(theta_x); 0 sin(theta_x) cos(theta_x)];
Ry = [cos(theta_y) 0 sin(theta_y); 0 1 0; -sin(theta_y) 0 cos(theta_y)];
Rz = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 1];

T = [0.017; -0.05; 0.03];

bunny_transRota = (Rx*Ry*Rz)*bunny';
bunny_transRota = bunny_transRota' + repmat(T',30571,1);

bunny_transRota = bunny_transRota + randn(30571,3)/100000;

%%
step = 10;
ind = [1:step:size(bunny,1)]
scatter3(bunny(ind,1),bunny(ind,2),bunny(ind,3),15,'o','filled');
hold on
scatter3(bunny_transRota(ind,1),bunny_transRota(ind,2),bunny_transRota(ind,3),15,'o','filled');

%%

objective = bunny;
current = bunny_transRota;
distanceThreshold = 0.1;

for i = 1:10
    step = 10;
    ind = [1:step:size(bunny,1)];
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
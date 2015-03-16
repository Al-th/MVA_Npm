function [pointCloud, covMat, pose] = loadDBData(dbName, nbNeighbors)
    pointCloud = load([dbName '.asc']);
    covMat = getCov(pointCloud, nbNeighbors); 
    pose = load([dbName '.pose']);

end
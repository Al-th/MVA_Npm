function pointCloud = load3dfile( filename )
    pc3dformat = load(filename);
    pointCloud = pc3dformat(:,1:3);
end


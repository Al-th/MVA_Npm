%script to transform 3d file in asc file 
 list_file = dir('./data/Bremen/*.3d');
 
 for i = 1:size(list_file,1)
     
    filename = list_file(i).name;
    pc3d = load3dfile(['./data/Bremen/',filename]);
    
    [~,name,~] = fileparts(filename);
    dlmwrite(['./data/',name,'.asc'],pc3d);
     
 end
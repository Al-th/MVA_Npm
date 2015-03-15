%script to move 3d file in asc file 
 list_file = dir('./data/hannover1/*.3d');
 
 for id = 1:length(list_file)
 
    filename = list_file(id).name;
    [~,name,~] = fileparts(filename);
    movefile(['./data/hannover1/',list_file(id).name],['./data/hannover1/', name, '.asc']); 
     
 end
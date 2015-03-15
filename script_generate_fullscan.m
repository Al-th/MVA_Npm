list_file = dir('./data/pose1/*.asc');
complete_pc = [];
for i = 1:size(list_file,1)
    pc = load(['./data/pose1/',list_file(i).name]);
    complete_pc = [complete_pc; pc];
end
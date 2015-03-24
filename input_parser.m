f = fopen('paris_54000.txt');
header = fscanf(f, '%d %d %d %d %d', [1 5]);
n_vertices = header(1); n_edges = header(2); T = header(3); n_cars = header(4); v_0 = header(5);
coords = fscanf(f, '%f %f', [2 n_vertices]);
edges = fscanf(f, '%d %d %d %d %d', [5 n_edges]);
fclose(f);

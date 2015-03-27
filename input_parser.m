f = fopen('test_round.in');
header = fscanf(f, '%d %d %d %d', [1 4]);
n_rows = header(1); n_columns = header(2); max_ham = header(3); max_slots = header(4);
pizza = fscanf(f, '%c', [n_rows n_columns]);
fclose(f);

hams = (pizza == 'H');
imagesc(hams);
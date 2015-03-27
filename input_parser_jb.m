f = fopen('~/Downloads/test_round.in');
header = fscanf(f, '%d %d %d %d', [1 4]);
n_rows = header(1); n_columns = header(2); max_ham = header(3); max_slots = header(4);
hams = fscanf(f, '%d', [n_columns n_rows])';

fclose(f);

% hams = (pizza == 'H');
% hams = padarray(hams, [12 12]);
% imagesc(hams);
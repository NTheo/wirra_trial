Ks = [1 12; 12 1; 2 6; 6 2; 3 4; 4 3];

for i = 1:size(Ks, 1)
    concentration = conv2(double(hams), ones(Ks(i,:)), 'same');
    imagesc(concentration);
    pause;
end
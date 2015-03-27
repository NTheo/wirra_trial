Ks = [1 12; 12 1; 2 6; 6 2; 3 4; 4 3; 11 1; 1 11; 10 1; 1 10; 5 2; 2 5; 9 1; 1 9; 3 3; 8 1; 1 8; 4 2; 2 4; 7 1; 1 7; 6 1; 1 6; 2 3; 3 2; 5 1; 1 5; 4 1; 1 4; 2 2; 3 1; 1 3];

all = zeros(size(hams));
concentrations = cell(1, size(Ks, 1));

map = zeros(size(hams));

scores = zeros([size(hams) size(Ks, 1)]);
 
lambda = 600;
% 
% for i = 1:size(Ks, 1)
%     concentration = conv2(double(hams), ones(Ks(i,:)), 'same');
% %     concentration = padarray(concentration, Ks(i, :));
% %     size(concentration)
% %     all = all + (concentration == 3);
% %     concentrations{i} = concentration;
%     
% 
%     curmap = prod(Ks(i,:)) ./ concentration+0.1*rand(size(concentration));
%     curmap(concentration < 3) = -1;
%     scores(:,:,i) = curmap;
%     continue;
%     pause;
%     
%     [I, J, V] = find(concentration >= 3);
%     for k = 1:numel(I)
%         starti = I(k) - floor(Ks(i, 1) / 2);
%         startj = J(k) - floor(Ks(i, 2) / 2);
%         endi = starti + Ks(i, 1);
%         endj = startj + Ks(i, 2);
%         if starti < 1 || startj < 1 || endi > size(hams, 1) || endj > size(hams, 2)
%             continue
%         end
%         map(starti:endi,startj:endj) = 1 + map(starti:endi,startj:endj);
%     end  
% end


for i = 1:size(Ks, 1)
    concentration = conv2(double(hams), ones(Ks(i,:)), 'same');


    [I, J, V] = find(concentration >= 3);
    for k = 1:numel(I)
       
        starti = I(k) - floor((Ks(i,1)-1)/2);
        startj = J(k) - floor((Ks(i,2)-1)/2);
        
        endi = starti + Ks(i, 1);
        endj = startj + Ks(i, 2);
        if starti < 1 || startj < 1 || endi > size(hams, 1) || endj > size(hams, 2)
            continue
        end
        map(starti:endi,startj:endj) = 1 + map(starti:endi,startj:endj);
    end  
end

map = map+1;
map = 1./map;


for i = 1:size(Ks, 1)
%     visited_freq = zeros(size(map));
    concentration = conv2(double(hams), ones(Ks(i,:)), 'same');
    curmap = prod(Ks(i,:)) ./ concentration;
     
    curmap(concentration < 3) = -1;
    scores(:,:,i) = curmap;

    
    [I, J, V] = find(concentration >= 3);
    for k = 1:numel(I)
        starti = I(k) - floor((Ks(i,1)-1)/2);
        startj = J(k) - floor((Ks(i,2)-1)/2);
        
        endi = starti + Ks(i, 1);
        endj = startj + Ks(i, 2);
        if starti < 1 || startj < 1 || endi > size(hams, 1) || endj > size(hams, 2)
            continue
        end
        score_freq = map(starti:endi,startj:endj);
        mean_score_freq = mean(score_freq(:));
%         for ind_i=starti:endi
%             for ind_j=startj:endj
%                 if visited_freq(ind_i, ind_j) == 0
%                      scores(ind_i,ind_j,i) = scores(ind_i,ind_j,i) + lambda*mean_score_freq;
%                      visited_freq(starti:endi,startj:endj,i) = 1;
%                 end
%             end
%         end
       scores(I(k),J(k),i) = scores(I(k),J(k),i)+lambda*mean_score_freq;
       
        
    end  
end


%%

occupied = zeros(size(hams));

[sorted_scores, I] = sort(scores(:), 'descend');

count = 0;
score_google = 0;
parts = zeros(numel(I), 4);

for t = 1:numel(I)
%     t
    [i,j,kernel] = ind2sub(size(scores), I(t));
    starti = i - floor((Ks(kernel,1)-1)/2);
    startj = j - floor((Ks(kernel,2)-1)/2);
    endi = starti + Ks(kernel, 1) - 1;
    endj = startj + Ks(kernel, 2) - 1;
    if starti < 1 || startj < 1 || endi > size(hams, 1) || endj > size(hams, 2)
        continue
    end
    if sum(sum(hams(starti:endi,startj:endj))) < 3
%         starti
%         startj
%         endi
%         endj
%         keyboard
      fprintf('error \n');
      break;
    end
    if nnz(occupied(starti:endi,startj:endj)) > 0
        continue
    else
        occupied(starti:endi,startj:endj) = 1;
        count = count + 1
        score_google = score_google+(endi-starti+1)*(endj-startj+1)
        parts(count,:) = [starti startj endi endj] - 1;
    end
    nnz(occupied == 0);
%     if nnz(occupied == 0) < 3000
%         break
%     end
end

parts = parts(1:count,:);
f = fopen('output.txt', 'w');
fprintf(f, '%d\n', count);
fprintf(f, '%d %d %d %d\n', parts');%(:,1)', parts(:,2)', parts(:,3)', parts(:,4)');
fclose(f);
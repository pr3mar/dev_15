[histograms, classes, files] = load_histogram_database('images',8);
len = size(histograms,1);
v_all = zeros(len^2, 1);
g_all= zeros(len^2, 1);
for i = 1:size(histograms,1)
    selected = histograms(i,:);
    v_score = zeros(size(histograms,1),1);
    v_groundtruth = zeros(size(histograms,1),1);
    for j = 1:size(histograms,1)
        if(i == j)
            continue;
        end
        v_score(j) = distance(selected, histograms(j,:), 'h');
        v_groundtruth(j) = (classes(i) == classes(j));
    end
    start_i = (i - 1) * len + 1;
    end_i = i * len;
    v_all(start_i:end_i) = v_score;
    g_all(start_i:end_i) = v_groundtruth;
end
% size(v_all), size(g_all)
[R, auc, tsh, f, point] = get_roc(v_all,g_all);
figure(1); clf; hold on;
plot(R(2,:),R(1,:)); 
plot(point(1),point(2), 'o');
t1 = sprintf('t = %1.3g, F = %1.3g, AUC = %1.3g',tsh ,f, auc);
tmp = imread(files{1});
[h,w,c] = size(tmp);
imgs = zeros(h,w,c,size(histograms,1));
for i = 1:size(histograms,1)
    imgs(:,:,:,i) = imread(files{i});
end
for i = 1:size(histograms,1)
    selected = imgs(:,:,:,i);   
    v_score = zeros(size(histograms,1),1);
    v_groundtruth = zeros(size(histograms,1),1);
    for j = 1:size(histograms,1)
        if(i == j)
            continue;
        end
        tmp = imgs(:,:,:,j);
        v_score(j) = distance(selected(:), tmp(:), 'ncc');
        v_groundtruth(j) = (classes(i) == classes(j));
    end
    start_i = (i - 1) * len + 1;
    end_i = i * len;
    v_all(start_i:end_i) = v_score;
    g_all(start_i:end_i) = v_groundtruth;
end
[R, auc, tsh, f, point] = get_roc(v_all,g_all);
plot(R(2,:),R(1,:)); 
plot(point(1),point(2), 'o'); 
title(sprintf('%s, t = %1.3g, F = %1.3g, AUC = %1.3g' , t1, tsh, f, auc)) ;
hold off;
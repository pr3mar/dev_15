[histograms, classes, files] = load_histogram_database('images',8);
v_all = zeros(size(histograms,1),1);
g_all= logical(zeros(size(histograms,1),1));
for i = 1:size(histograms,1)
    selected = histograms(i,:);
    v_score = zeros(size(histograms,1),1);
    v_groundtruth = logical(zeros(size(histograms,1),1));
    for j = 1:size(histograms,1)
        if(i == j)
            continue;
        end
        v_score(j) = distance(selected, histograms(j,:), 'h');
        v_groundtruth(j) = (classes(i) == classes(j));
    end
    v_all = v_score + v_all;
    g_all = bsxfun(@or, g_all, v_groundtruth);
end

[R, auc, tsh, f, point] = get_roc(v_all,g_all);
figure(1); clf;
plot(R(2,:),R(1,:)); hold on;
plot(point(1),point(2), 'o'); hold off;
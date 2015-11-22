labels = [1 0 1 1 1 0 0 0];
th1 = 0.33;
th2 = 0.1;
scores1 = [0.5 0.3 0.6 0.22 0.4 0.51 0.2 0.33];
scores2 = [0.04 0.1 0.68 0.22 0.4 0.11 0.8 0.53];

[R, auc, f, point] = get_roc(scores1,labels)
figure(1); clf;
plot(R(2,:),R(1,:)); hold on;
plot(point(1),point(2), 'o');
% [R, auc, f] = get_roc(scores2,labels)
% plot(R(2,:),R(1,:)); hold off;
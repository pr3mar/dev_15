% dual PCA

figure(2); clf;
P = load('points.txt') ;
% subplot(1,2,1);
plot(P(1,:),P(2,:),'b+'); hold on;
for i = 1 : size(P,2)
   text( P(1,i)-0.5, P(2,i), num2str(i)); 
end
xlabel('x_1'); ylabel('x_2');
xlim([-10 10]);
ylim([-10 10]);

mu = mean(P, 2);
[m, N] = size(P);
Pn = bsxfun(@minus, P, mu);

C = (1/(m-1)) * (Pn') * Pn;
[U, S, V] = svd(C);
Un = Pn * U * ((m - 1) * S)^(-1/2);

Ps = Un(:,1:2)' * bsxfun(@minus, P, mu)
Pp = bsxfun(@plus, Un(:,1:2) * Ps, mu)

plot(Pp(1,:), Pp(2,:), 'o');

% project to dual PCA space: y = U' * (xq - mu)
% project to original space: xq = U * y + mu

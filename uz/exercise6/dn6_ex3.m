% (a)
[db, dims] = read_imgs('1');

% (b)
[U, mu] = dual_pca(db);

figure(1); clf;
for i = 1:5
    subplot(2,5,i); colormap gray;
    imagesc(reshape(db(:,i), dims(1), dims(2))); axis equal; axis tight;
    subplot(2,5,i+5); colormap gray;
    imagesc(reshape(U(:,i), dims(1), dims(2))); axis equal; axis tight;
end

figure(2); clf; colormap gray;
subplot(1,3,1);
imagesc(reshape(db(:,1), dims(1), dims(2))); axis equal; axis tight;
% reset 4074
subplot(1,3,2);
d2 = db;
d2(4074,:) = 0;
p2 = U' * bsxfun(@minus, d2, mu);
p2n = bsxfun(@plus, U * p2, mu);
imagesc(reshape(p2n(:,1), dims(1), dims(2))); axis equal; axis tight;
% reset 5
subplot(1,3,3);
d3 = db;
d3(5,:) = 0;
p3 = U' * bsxfun(@minus, d3, mu);
p3n = bsxfun(@plus, U * p3, mu);
imagesc(reshape(p3n(:,1), dims(1), dims(2))); axis equal; axis tight;

% (c)
figure(3); clf; colormap gray;
subplotSize = 8; selectedImg = 24;
subplot(1,subplotSize,1);
imagesc(reshape(db(:,selectedImg), dims(1), dims(2))); axis equal; axis tight;
[hu, wu] = size(U);
for i = 0:(subplotSize - 2)
    Up = zeros(hu, wu);
    Up(:, 1:2^i) = U(:, 1:2^i);
    projection = Up' * bsxfun(@minus, db, mu);
    proj_back = bsxfun(@minus, Up * projection, mu);
    
    subplot(1,subplotSize,i + 2);
    imagesc(reshape(proj_back(:,selectedImg), dims(1), dims(2))); axis equal; axis tight;
    title(sprintf('%d', 2^i));
end

% (e)


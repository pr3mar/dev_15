% % (a)
% [db, dims] = read_imgs('1');
% 
% % (b)
% [U, mu] = dual_pca(db);
% 
% figure(1); clf;
% for i = 1:5
%     subplot(2,5,i); colormap gray;
%     imagesc(reshape(db(:,i), dims(1), dims(2))); axis equal; axis tight;
%     subplot(2,5,i+5); colormap gray;
%     imagesc(reshape(U(:,i), dims(1), dims(2))); axis equal; axis tight;
% end
% 
% figure(2); clf; colormap gray;
% subplot(1,3,1);
% imagesc(reshape(db(:,1), dims(1), dims(2))); axis equal; axis tight;
% % reset 4074
% subplot(1,3,2);
% img = db(:,1);
% img(4074) = 0;
% p2 = U' * bsxfun(@minus, img, mu);
% p2n = bsxfun(@plus, U * p2, mu);
% imagesc(reshape(p2n, dims(1), dims(2))); axis equal; axis tight;
% % reset 5
% subplot(1,3,3);
% img = db(:,1);
% img(5) = 0;
% p3 = U' * bsxfun(@minus, img, mu);
% p3n = bsxfun(@plus, U * p3, mu);
% imagesc(reshape(p3n, dims(1), dims(2))); axis equal; axis tight;
% 
% % (c)
% figure(3); clf; colormap gray;
% subplotSize = 8; selectedImg = 24;
% subplot(1,subplotSize,1);
% imagesc(reshape(db(:,selectedImg), dims(1), dims(2))); axis equal; axis tight;
% [hu, wu] = size(U);
% for i = 0:(subplotSize - 2)
%     Up = zeros(hu, wu);
%     Up(:, 1:2^i) = U(:, 1:2^i);
%     projection = Up' * bsxfun(@minus, db(:,selectedImg), mu);
%     proj_back = bsxfun(@plus, Up * projection, mu);
%     
%     subplot(1,subplotSize,i + 2);
%     imagesc(reshape(proj_back, dims(1), dims(2))); axis equal; axis tight;
%     title(sprintf('%d', 2^i));
% end
% 
% % (d)
% 
% [db, dims] = read_imgs('2');
% [U, mu] = dual_pca(db);
% copy_mu = mu;
% proj = U' * bsxfun(@minus, copy_mu, mu);
% proj_2 = proj;
% proj_2(2) = proj_2(2) + 2;
% proj_back = bsxfun(@plus, U * proj, mu);
% imshow(reshape(uint8(proj_back),dims(1),dims(2))); colormap gray
% for x = linspace (-20, 20 , 500)
%     proj(2) = proj(2) + 5 * sin(x);
%     proj(3) = proj(3) + 5 * cos(x);
%     
%     proj_back = bsxfun(@plus, U * proj, mu);
%     
%     figure (4) ; imshow ( reshape(uint8(proj_back),dims(1),dims(2)) ) ;
%     pause (0.1) ;
% end ;

% (e)
[db, dims] = read_imgs('1');
[U, mu] = dual_pca(db);
elephant = double(reshape(rgb2gray(imread('elephant.jpg')), dims(1) * dims(2), 1));
proj = U' * bsxfun(@minus, elephant, mu);
proj_back = bsxfun(@plus, U * proj, mu);
figure(5); clf; colormap gray;
subplot(1,2,1);
imagesc(reshape(elephant, dims(1), dims(2))); axis equal; axis tight;
subplot(1,2,2);
imagesc(reshape(proj_back, dims(1), dims(2))); axis equal; axis tight;



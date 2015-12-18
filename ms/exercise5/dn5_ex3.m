img = rgb2gray(imread('boat.jpg'));
[h, w] = size(img);
sigma = 1;
[img_x, img_y] = image_derivatives(img, sigma);
img_energy = abs(img_x) + abs(img_y);
cum_en = cumulative_energy(img_energy);

figure(1); clf; colormap gray;
subplot(1,3,1); imagesc(img); axis equal; axis tight;
subplot(1,3,2); imagesc(img_energy); axis equal; axis tight;
subplot(1,3,3); imagesc(cum_en); axis equal; axis tight;

s = seam(cum_en);
size(s)
figure(2); clf;
subplot(1,2,1); imagesc(img_energy); axis equal; axis tight; hold on;
plot(s(:,1), 1:h, 'r.'); hold off;
subplot(1,2,2); imagesc(cum_en); axis equal; axis tight; hold on;
plot(s(:,1), 1:h, 'r.'); hold off;

K = 50; TT = 50;
figure(3); clf; colormap gray;
subplot(1,3,1); imagesc(img); axis equal; axis tight; title('original');
subplot(1,3,2); imagesc(imresize(img, [h - K, w - TT])); axis equal; axis tight; title('resized');
carved = seam_carving2(img, TT, K);
subplot(1,3,3); imagesc(carved); axis equal; axis tight; title('seam carved');
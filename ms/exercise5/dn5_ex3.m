img = rgb2gray(imread('truck.jpg'));
sigma = 1;
[img_x, img_y] = image_derivatives(img, sigma);
img_energy = abs(img_x) + abs(img_y);
cum_en = cumulative_energy(img_energy);

figure(1); clf; %colormap gray;
subplot(1,3,1); imagesc(img); axis equal; axis tight;
subplot(1,3,2); imagesc(img_energy); axis equal; axis tight;
subplot(1,3,3); imagesc(cum_en); axis equal; axis tight;

s = seam(cum_en);

figure(2); clf;
subplot(1,3,2); imagesc(img_energy); axis equal; axis tight; hold on;
plot(s(:,1), s(:,2));
subplot(1,3,3); imagesc(cum_en); axis equal; axis tight;


img = rgb2gray(imread('graf/graf1.png'));
%(a) Hessian detector
tsh = 100;
[px, py] = hessian_points(img, 1, tsh);
figure(1);clf; colormap gray;
subplot(1,4,1);imagesc(img); axis tight; axis equal; hold on;
plot(px, py, 'r+'); hold off;
title(sprintf('tsh=%1.f, sigma=%1.f', tsh, 1));
for i = 1:3
    [px, py] = hessian_points(img, i * 3, tsh);
    figure(1); colormap gray;
    subplot(1,4,i+1);imagesc(img); axis tight; axis equal; hold on;
    plot(px, py, 'r+'); hold off;
    title(sprintf('tsh=%1.f, sigma=%1.f', tsh, i*3));
end


%(b) Harris detector
sigma = 3; tsh = 100;
[px, py] = harris_points(img, 1, tsh);
% size(px);
figure(2); clf; colormap gray;
subplot(1,4,1);imagesc(img); axis tight; axis equal; hold on;
plot(px, py, 'r+'); hold off;
title(sprintf('tsh=%1.f, sigma=%1.f', tsh, 1));
for i = 1:3
    [px, py] = harris_points(img, i * sigma, tsh);
    figure(2); colormap gray;
    subplot(1,4,i+1);imagesc(img); axis tight; axis equal; hold on;
    plot(px, py, 'r+'); hold off;
    title(sprintf('tsh=%1.f, sigma=%1.f', tsh, i*sigma));
end
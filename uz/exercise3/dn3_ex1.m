% (a)
% Iy = d/dy g(y) * [g(x) * I(x,y)];
% Iyy = d/dy g(y) * [g(x) * Iy(x,y)];
% Ixy = d/dx g(x) * d/dy g(y) * I(x,y)];
% (b)
impulse = zeros(25, 25); impulse(13,13) = 255;
sigma = 6;
G = gauss(sigma);
D = gaussdx(sigma);
figure(1);
subplot(2,3,1);
imshow(impulse);
subplot(2,3,4);
imagesc(conv2(conv2(impulse, G), G')); title('G,G'''); axis tight; axis equal;

subplot(2,3,2);
imagesc(conv2(conv2(impulse, G), D')); title('G,D''');axis tight; axis equal;
subplot(2,3,3);
imagesc(conv2(conv2(impulse, D), G')); title('D,G''');axis tight; axis equal;

subplot(2,3,5);
imagesc(conv2(conv2(impulse, D'), G)); title('D'',G');axis tight; axis equal;
subplot(2,3,6);
imagesc(conv2(conv2(impulse, G'), D)); title('G'',D');axis tight; axis equal;

% (c)
museum = rgb2gray(imread('museum.jpg'));
sigma = 1;
figure(2); colormap gray;
subplot(2,4,1); imagesc(museum); axis tight equal;
[Ix, Iy] = image_derivatives(museum, sigma);
subplot(2,4,2); imagesc(Ix); title('Ix');axis tight equal;
subplot(2,4,3); imagesc(Iy); title('Iy'); axis tight equal;
[Ixx, Iyy, Ixy] = image_derivatives2(museum, sigma);
subplot(2,4,5); imagesc(Ixx); title('Ixx'); axis tight equal;
subplot(2,4,6); imagesc(Ixy); title('Ixy'); axis tight equal;
subplot(2,4,7); imagesc(Iyy); title('Iyy'); axis tight equal;
[Imag, Ideg] = gradient_magnitude(museum, sigma);
subplot(2,4,4); imagesc(Imag); title('Imag'); axis tight equal;
subplot(2,4,8); imagesc(Ideg); title('Ideg'); axis tight equal;

% (d)
img = rgb2gray(imread('lena.png'));
sigma = sqrt(2); level = 5;
img_pyramid = gauss_pyramid(img, sigma, level);
figure(3); colormap gray;
for i = 1:level
    subplot(1,level, i); imagesc(uint8(img_pyramid{i})); axis equal; axis tight;
end
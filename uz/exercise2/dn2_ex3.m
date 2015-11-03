% % (a)
% lena = rgb2gray(imread('lena.png'));
% figure(1); clf;
% Icg = imnoise(lena, 'gaussian', 0, 0.01);
% subplot(2,2,1); imshow(Icg); colormap gray;
% axis equal; axis tight; title('gaussian noise');
% Ics = imnoise(lena, 'salt & pepper', 0.1);
% subplot(2,2,2); imshow(Ics); colormap gray;
% axis equal; axis tight; title('salt & pepper');
% Icg_b = gaussfilter(double(Icg), 1);
% Ics_b = gaussfilter(double(Ics), 1);
% subplot(2,2,3); imshow(uint8(Icg_b)); colormap gray;
% axis equal; axis tight; title('filtered');
% subplot(2,2,4); imshow(uint8(Ics_b)); colormap gray;
% axis equal; axis tight; title('filtered');

% % (b)
% museum = rgb2gray(imread('museum.jpg'));
% figure(2); clf;
% subplot(1,2,1); imshow(museum); colormap gray; axis tight; axis equal;
% subplot(1,2,2); imshow(uint8(sharp_filter(double(museum)))); colormap gray; axis tight; axis equal;

% (c)
x = [zeros(1,14), ones(1,11),zeros(1,15)]; 
xc = x; xc(11) = 5; xc(18) = 5;
figure(3);
subplot(1,4,1); plot(x); axis([1, 40, 0, 7]); title('input');
subplot(1,4,2); plot(xc); axis([1, 40, 0, 7]); title('corrupted');
g = gauss(1);
x_g = conv(xc, g, 'same');
x_m = simple_median(xc, 5);
subplot(1,4,3); plot(x_g); axis([1, 40, 0, 7]); title('gauss');
subplot(1,4,4); plot(x_m); axis([1, 40, 0, 7]); title('median');







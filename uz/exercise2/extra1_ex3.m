lena = rgb2gray(imread('lena.png'));
figure(1); clf;
Icg = imnoise(lena, 'gaussian', 0, 0.01);
subplot(2,3,1); imshow(Icg); colormap gray;
axis equal; axis tight; title('gaussian noise');
Ics = imnoise(lena, 'salt & pepper', 0.1);
subplot(2,3,4); imshow(Ics); colormap gray;
axis equal; axis tight; title('salt & pepper');
Icg_b = gaussfilter(double(Icg), 1);
Ics_b = gaussfilter(double(Ics), 1);
subplot(2,3,2); imshow(uint8(Icg_b)); colormap gray;
axis equal; axis tight; title('gaussian filtered');
subplot(2,3,5); imshow(uint8(Ics_b)); colormap gray;
axis equal; axis tight; title('gaussian filtered');

median_2d = median2d(Icg, 3);
subplot(2,3,3); imshow(uint8(median_2d)); colormap gray;
axis equal; axis tight; title('median filtered');

median_2d = median2d(Ics, 3);
subplot(2,3,6); imshow(uint8(median_2d)); colormap gray;
axis equal; axis tight; title('median filtered');

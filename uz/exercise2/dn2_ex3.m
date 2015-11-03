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

% (b)

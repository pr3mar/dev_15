img = rgb2hsv(imread('hsvWork.jpg'));
figure(1); clf;
% subplot(1,4,1); imagesc(hsv2rgb(img)); axis equal; axis tight;
% for i = 1:3
%     img_copy = img;
%     img_copy(:,:,i) = 0.5;
%     subplot(1,4,i + 1); imagesc(hsv2rgb(img_copy)); axis equal; axis tight;
% end;


% histogram stretching with hsv color space
figure(2); clf;
subplot(1,2,1); imagesc(hsv2rgb(img)); axis equal; axis tight; title('original');
stretched = histstrech_hsv(img);
subplot(1,2,2); imagesc(hsv2rgb(stretched)); axis equal; axis tight; title('stretched s, v');
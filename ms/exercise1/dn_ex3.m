% % (a) --> show different channels of images
% trucks = imread('trucks.jpg');
% figure(1); colormap gray;
% subplot(2, 4, 1); imshow(trucks); title('original');
% subplot(2, 4, 2); imshow(trucks(:,:,1)); title('red');
% subplot(2, 4, 3); imshow(trucks(:,:,2)); title('green');
% subplot(2, 4, 4); imshow(trucks(:,:,3)); title('blue');
% trucks_hsv = rgb2hsv(trucks);
% subplot(2, 4, 6); imshow(trucks_hsv(:,:,1)); title('hue');
% subplot(2, 4, 7); imshow(trucks_hsv(:,:,2)); title('saturation');
% subplot(2, 4, 8); imshow(trucks_hsv(:,:,3)); title('value');

% % (b) --> change channels according to f
% trucks_rgb = imread('trucks.jpg');
% trucks_hsv = rgb2hsv(trucks_rgb);
% figure(2); clf;
% x = 1;
% for i = 1:3
%     for j = 1:10
%         f = (j - 1) / 9;
%         subplot(6, 10, x);
%         tmp = trucks_rgb;
%         tmp(:,:,i) = 255 .* f;
%         imshow(tmp);
%         tmp = trucks_hsv;
%         subplot(6, 10, x + 30);
%         tmp(:,:,i) = f;
%         imshow(hsv2rgb(tmp));
%         x = x + 1;
%     end;
% %     x = x + 10;x
% end;

% (c) --> different color spaces
trucks = imread('trucks.jpg');
figure(3); clf;
% original
subplot(1,4,1); imshow(trucks); title('original');
% treshold
blue = trucks(:,:,3) > 200;
subplot(1,4,2); imshow(blue); title('treshold >200');
% normalized
trucks = double(trucks);
sumAll = double(trucks(:,:,1) + trucks(:,:,2) + trucks(:,:,3));
blue = trucks(:,:,3) ./ sumAll;
blue = blue > 0.5;
subplot(1,4,3); imshow(blue); title('normalized');
% hue treshold
% 0.55 - 0.75
trucks_hsv = rgb2hsv(imread('trucks.jpg'));
blue_hue = trucks_hsv(:,:,1) > 0.55 & trucks_hsv(:,:,1) <= 0.73;
subplot(1,4,4); imshow(blue_hue); title('hue treshold');

I = ones (20 , 255 , 3) ;
I (: , : , 1) = ones (20 , 1) * linspace (0 , 1 , 255) ;
figure; image ([0 , 1] , [0 , 1] , hsv2rgb (I) ) ;

% I1 = imread('http://i.stack.imgur.com/1KyJA.jpg');
% I2=I1;
% I2(:,:,1)=I1(:,:,2);
% I2(:,:,2)=I1(:,:,1);
% imshowpair(I1,I2, 'montage');
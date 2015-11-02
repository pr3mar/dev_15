umbrellas = imread('umbrellas.jpg');
hist3 = myhist3(umbrellas, 8);
figure(1); clf; 
subplot(1,3,1); bar3(hist3(:,:,1));
subplot(1,3,2); bar3(hist3(:,:,2));
subplot(1,3,3); bar3(hist3(:,:,3));
% % (b)
% signal = load('signal.txt');
% kernel = load('kernel.txt');
% 
% figure(1); clf;
% plot(signal); hold on;
% plot(kernel);
% convolution = simple_convolution(signal, kernel);
% plot(convolution);
% embedded = conv(signal, kernel, 'same');
% plot(embedded);  hold off;

% % (d) 
% figure(2); clf;
% [gaus_kernel, x] = gauss(0.5);
% plot(x, gaus_kernel); hold on;
% [gaus_kernel, x] = gauss(1);
% plot(x, gaus_kernel); 
% [gaus_kernel, x] = gauss(2);
% plot(x, gaus_kernel); 
% [gaus_kernel, x] = gauss(3);
% plot(x, gaus_kernel); 
% [gaus_kernel, x] = gauss(4);
% plot(x, gaus_kernel); hold off;

% (e)
signal = load('signal.txt');
kernel_1 = gauss(2);
kernel_2 = [0.1, 0.6, 0.4];
figure(3); clf;
subplot(1,4,1); plot(signal); axis tight;
subplot(1,4,2); plot(conv(conv(signal, kernel_1), kernel_2)); axis tight;
subplot(1,4,3); plot(conv(conv(signal, kernel_2), kernel_1)); axis tight;
subplot(1,4,4); plot(conv(signal, conv(kernel_1,kernel_2))); axis tight;




% (a) --> manual treshold (65)
A = rgb2gray(imread('bird.jpg'));
treshold = 65;
M = A > treshold;
figure(1) ; imagesc(M); colormap gray
figure ; imagesc(imread('bird.jpg')); 


% (b) --> histogram (provided code)
[H, bins] = myhist(A, 10);
c = hist(double(A), 10);
figure(2) ; bar(bins, H);
figure ; bar(c);

% (c) --> embedded histogram function
I = double(rgb2gray(imread('umbrellas.jpg')));
P = I(:); % 2d to 1d vector
figure(3); clf;

bins = 10;
H = hist(P, bins);
H = H/sum(H); % normalize
subplot(1,3,1); bar(H, 'b');

bins = 20;
H = hist(P, bins);
H = H/sum(H); % normalize
subplot(1,3,2); bar(H, 'b');

bins = 30;
H = hist(P, bins);
H = H/sum(H); % normalize
subplot(1,3,3); bar(H, 'b');

% (d) --> other images (?)

% (e) --> otsu's threshold
bird = double(rgb2gray(imread('bird.jpg')));
threshold = threshold_otsu(bird);
O = bird > threshold;
figure(4) ; imagesc(O); colormap gray



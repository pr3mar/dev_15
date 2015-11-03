cat1 = double(imread('cat1.jpg'));
cat2 = double(imread('cat2.jpg'));
copy1 = zeros(size(cat1)); copy2 = zeros(size(cat2));
gaus = fspecial('gauss', 3, 10);
lap = fspecial('laplacian', 1);

for i = 1:3
    copy1(:,:,i) = conv2(cat1(:,:,i),gaus,'same');
    copy2(:,:,i) = conv2(cat2(:,:,i),lap,'same');
end;

figure(1); clf; imshow(uint8(copy1 + copy2));
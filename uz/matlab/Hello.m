[img, map, alpha] = imread('image1.jpg');
[x, y, c] = size(img);
[img, ] = sqrt(double(img));
image(img);
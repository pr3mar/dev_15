img1 = imread('autumn1.jpg');
img2 = imread('autumn2.jpg');
mask = rgb2gray(imread('autumn_mask.png'));
smooth = blend_smooth(img1, img2, mask,5);
binary = blend_binary(img1, img2, mask);

img = rgb2gray(imread('eagle.jpg'));
l = 4;
pyramid = laplace_pyramid(img, l);
g_p = gauss_pyramid(img, l);
% subplot(1,(l + 1), 1); imagesc(img); colormap gray; axis tight; axis equal;
figure(2); colormap gray;
for i = 1:l
    subplot(2, l, i);
    imagesc(g_p{i});
    axis tight; axis equal;
    
    subplot(2, l, i + l);
    imagesc(pyramid{i});
    axis tight; axis equal;
end

% sea = rgb2gray(imread('underwater.jpg'));
% eagle = rgb2gray(imread('eagle.jpg'));
mask = rgb2gray(imread('autumn_mask.png'));
level = 4;
sea = imread('autumn1.jpg');
eagle = imread('autumn2.jpg');
eagle_p = laplace_pyramid(eagle, level);
sea_p = laplace_pyramid(sea, level);

% eagle_p = cell(3,1);
% sea_p = cell(3,1);
% for i = 1:3
%     eagle_p{i} = laplace_pyramid(eagle(:,:,i), level);
%     sea_p{i} = laplace_pyramid(sea(:,:,i), level);
% end
mask_p = gauss_pyramid(mask, level);
result_p = sea_p;
result = zeros(size(eagle));
% for k = 1:3
    for i = 1:level
        [iter_y, iter_x] = find(mask_p{i} ~= 0);
        mask_p{i} = double(mask_p{i}) / max(mask_p{i}(:));
        for j = 1:numel(iter_y)
            result_p{i}(iter_y(j), iter_x(j),:) = ...
                  mask_p{i}(iter_y(j), iter_x(j)) * eagle_p{i}(iter_y(j), iter_x(j),:) + ...
                  (1 - mask_p{i}(iter_y(j), iter_x(j))) * sea_p{i}(iter_y(j), iter_x(j),:);
%             result_p{k}{i}(iter_y(j), iter_x(j)) = ...
%                   mask_p{i}(iter_y(j), iter_x(j)) * eagle_p{k}{i}(iter_y(j), iter_x(j)) + ...
%                   (1 - mask_p{i}(iter_y(j), iter_x(j))) * sea_p{k}{i}(iter_y(j), iter_x(j));

        end
%         result(:,:,k) = result(:,:,k) + result_p{k}{i};
        result = result + result_p{i};
    end
% end
figure(1); clf; 
subplot(1,3,1); imagesc(binary); axis tight; axis equal; title('binary');
subplot(1,3,2); imagesc(smooth); axis tight; axis equal; title('smooth');
subplot(1,3,3); imagesc(uint8(result)); axis tight; axis equal; title('laplace pyramid');
figure(2);clf; imagesc(uint8(result)); axis tight; axis equal; title('laplace pyramid');
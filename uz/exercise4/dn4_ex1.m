img = rgb2gray(imread('test_points.png'));
% %(a) Hessian detector -- not working (still)
% % img_hess = hessian_points(img, 1, 100);
% figure(1);clf; colormap gray;
% % subplot(1,2,1); imagesc(img); axis tight; axis equal;
% % subplot(1,2,2); imagesc(img_hess); axis tight; axis equal;
% tsh = 100;
% % [px, py] = hessian_points(img, 1, tsh);
% I_h = hessian_points(img, 1, tsh);
% % subplot(1,4,1);imagesc(img); axis tight; axis equal; hold on;
% % plot(px, py, 'r+'); hold off;
% subplot(1,4,1); imagesc(I_h); axis tight; axis equal; hold on;
% title(sprintf('tsh=%1.f, sigma=%1.f', tsh, 1));
% for i = 1:3
% %     [px, py] = hessian_points(img, i * 3, tsh);
% %     subplot(1,4,i+1);imagesc(img); axis tight; axis equal; hold on;
% %     plot(px, py, 'r+'); hold off;
%     I_h = hessian_points(img, i * 3, tsh);
%     subplot(1,4,i+1);imagesc(I_h); axis tight; axis equal; hold on;
%     title(sprintf('tsh=%1.f, sigma=%1.f', tsh, i*3));
% end


%(b) Harris detector


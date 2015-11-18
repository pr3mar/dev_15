function [ rho, theta ] = hough_find_lines...
    ( Ie, bins_rho, bins_theta, threshold )
    [h, w] = size(Ie);
    hough = zeros(bins_rho, bins_theta);
    theta = 0:(pi/bins_theta):pi; theta = theta(1:end-1);
%     theta = theta - pi/2;
%     D = length(diag(Ie));
    D = sqrt(h^2 + w^2);
    rho = -D:(2*D/bins_rho):D; rho = rho(1:end-1); % 2 * D??
    [edge_y, edge_x] = find(Ie > 0);

    cosine = (0:h-1)' * cos(theta);
    sine = (0:w-1)' * sin(theta);
    acc = zeros(numel(edge_x), numel(theta));
    ac = size(acc), co = size(cosine), si = size(sine), max(edge_x), max(edge_y)
    acc(1:numel(edge_x),:) = cosine(edge_y,:) + sine(edge_x,:);
    
    for i = 1:numel(theta)
    %     for i = 1:numel(edge_x)
        hough(:,end - i + 1) = hist(acc(:,end - i + 1), rho);
%         rho_iter = edge_x(i) * cos(theta) + edge_y(i) * sin(theta);
%         id = floor(((rho_iter + D)/(2*D)) * bins_rho) + 1;
%         id_theta = find(id < bins_rho);
%         id = id(id < bins_rho);
%         for k = 1:numel(id)
%             hough(id(k), id_theta(k)) = hough(id(k), id_theta(k)) + 1;
%         end
    end
    figure(1); subplot(1,2,1); imagesc(hough); title('acc'); colormap jet
    hough = nonmaxima_suppression_box(hough);
    subplot(1,2,2); imagesc(hough); title('acc'); colormap jet
    thresholded = hough > threshold;
    [rho, theta] = find(thresholded);
end
function [ rho, theta ] = hough_find_lines...
    ( Ie, bins_rho, bins_theta, threshold )
    [h,w] = size(Ie);
    hough = zeros(bins_rho, bins_theta);
    theta = 0:pi/bins_theta:pi; theta = theta(1:end-1);
    theta = theta - pi/2;
    D = length(diag(Ie));
    rho = -D:2*D/bins_rho:D; rho = rho(1:end-1); % 2 * D??
    [edge_x, edge_y] = find(Ie > 0);

    cosine = (0:h-1)' * cos(theta);
    sine = (0:w-1)' * sin(theta);
    acc = zeros(numel(edge_x), numel(theta));
%     ac = size(acc), co = size(cosine), si = size(sine), max(edge_x), max(edge_y)
    acc(1:size(edge_x),:) = cosine(edge_x,:) + sine(edge_y,:);
    
    for i = 1:numel(theta)
%         rho_iter = edge_x * cos(theta(i)) + edge_y * sin(theta(i));
        hough(:,i) = hist(acc(:,i), rho);
    end
    figure(1); imagesc(hough);%title('acc')
%      plot(rho_iter)
end
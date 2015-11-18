function [ out_rho, out_theta ] = hough_find_lines_1...
    ( Ie, bins_rho, bins_theta, threshold )
    
    [h, w] = size(Ie);
    hough = zeros(bins_rho,bins_theta);
    D = length(diag(Ie));
    theta_val = 0:pi/bins_theta:pi;
    theta_val = theta_val(1:end-1);
    theta_val = theta_val - pi/2;
    rho_val = -D:2*D/bins_rho:D;
    rho_val = rho_val(1:end-1);
    numel(rho_val)
    numel(theta_val)
    
    [pointY, pointX] = find(Ie > 0);
%     size(pointX), size(theta_val)
    acc = zeros(numel(pointX), numel(theta_val));
%     figure; 
%     plot(pointX(1) * cos(theta_val) + pointY(1) * sin(theta_val))
%     hold on
%     plot(pointX(2) * cos(theta_val) + pointY(2) * sin(theta_val))
    cosine = (0:w-1)' * cos(theta_val);
    sine = (0:h-1)' * sin(theta_val);
    acc(1:size(pointX),:) = cosine(pointX,:) + sine(pointY,:);
    for i = 1:numel(theta_val)
%         h_size = size(hough(i,:))
%         hist_size = size(hist(acc(:,i), rho_val))
        hough(:,i) = hist(acc(:,i), rho_val);
    end
    
    
    figure; imagesc(hough);
    out_rho = rho_val;
    out_theta = theta_val;
end


function [out_rho, out_theta] = hough_(Ie,bins_rho, bins_theta, threshold)
    % works!

    acc = zeros(bins_rho, bins_theta);
    theta_vals = 0:(pi/bins_theta):pi; theta_vals = theta_vals(1:end-1);
%     rho = -D:(2*D/bins_rho):D; rho = rho(2:end);
%     size(theta), size(rho);
    
    [h,w] = size(Ie);
%     D = length(diag(Ie));
    D = sqrt(h^2 + w^2);
    [edge_y, edge_x] = find(Ie > 0);
%     size(edge_y), size(edge_x);
    
    for i = 1:numel(edge_y)
        rho_iter = edge_x(i) * cos(theta_vals) + edge_y(i) * sin(theta_vals);
        rho_iter = floor( (rho_iter/(2*D) + 0.5) * bins_rho );
        
        for j = 1:numel(rho_iter)
            theta = numel(rho_iter) - j;
            rho = rho_iter(j);
            if ( 0 < rho && rho <= bins_rho ) && ( 0 <  theta && theta <= bins_theta)
                acc(rho, theta) = acc(rho, theta) + 1;
            end
        end
    end
%     figure(1); subplot(1,2,1); imagesc(acc); axis tight; axis equal; colormap jet
    acc = nonmaxima_suppression_box(acc);
%     subplot(1,2,2); imagesc(acc); axis tight; axis equal; colormap jet
%     imagesc(acc); colormap jet
    thresholded = acc > threshold;
    [out_rho, out_theta] = find(thresholded);
    out_rho = (out_rho / bins_rho - 0.5) * 2 * D;
    out_theta = (out_theta/ bins_theta - 0.5) * pi;
end
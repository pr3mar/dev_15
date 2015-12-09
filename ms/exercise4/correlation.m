function [ corr ] = correlation( A )
    px = sum(A,1)';
    py = sum(A,2);
    mux = (1:numel(px)) * px;
    muy = (1:numel(py)) * py;
    sigmax = sqrt(sum( ((1:numel(px)) - mux).^2' .* px));
    sigmay = sqrt(sum( ((1:numel(py)) - muy).^2' .* py));
%     if sigmax == 0 || sigmay == 0
%         sigmax, sigmay
%     end
    corr = 0;
    for i = 1:size(A,1)
        for j = 1:size(A,2)
            corr = corr + (((j - mux) * (i - muy) * A(i,j))/(sigmax*sigmay));
        end
    end
    if isnan(corr)
        corr = 0;
    end
end


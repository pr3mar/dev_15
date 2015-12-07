function [ corr ] = correlation( A )
    [y, x] = find(A);
    px = sum(A,2)
    py = sum(A,1)'
    mux = (1:numel(px)) * px
    muy = (1:numel(py)) * py
    sigmax = sqrt(sum( ((1:numel(px)) - mux).^2' .* px))
    sigmay = sqrt(sum( ((1:numel(py)) - muy).^2' .* py))
    corr = 0;
    for i = 1:size(y)
        for j = 1:size(x)
            corr = corr + ( (x(j) - mux) * (y(i) - muy) * A(y(i),x(j))/(sigmax*sigmay) );
        end
    end
end


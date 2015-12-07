function [ corr ] = correlation( A )
    [i, j] = find(A);
    px = sum(A,2);
    py = sum(A,1);
    mux = sum( (1:numel(px))' .* px);
    muy = sum( (1:numel(py)) .* py);
    sigmax = sqrt(sum( (1:numel(px) - mux) .* px));
    sigmay = sqrt(sum( (1:numel(py) - muy) .* py));
    corr = sum( ((j - mux) * (i - muy)' .* A(i,j)) / (sigmax * sigmay) );
end


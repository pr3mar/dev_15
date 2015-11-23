function P = gauss_pyramid(I, l)

P = cell(l, 1);

P{1} = double(I);

for i = 2:l
    P{i} = gaussfilter(P{i-1}, sqrt(2));
end


function [ s ] = seam( cum_en )
    [h, ~] = size(cum_en);
    [~, s_index] = min(cum_en(h,2:(end-1)));
    s = zeros(h, 1); s(end) = s_index;
    for i = (h - 1):-1:1
        map = containers.Map(1:3,[s(i + 1) - 1, s(i + 1), s(i + 1) + 1]);
        [~, tmp] = min([cum_en(i,s(i + 1) - 1), cum_en(i,s(i + 1)), cum_en(i,s(i + 1)+ 1)]);
        s(i) = map(tmp);
    end
    s = [s ; 1:h];
end


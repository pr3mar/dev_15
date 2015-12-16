function [ s ] = seam( cum_en )
    [h, w] = size(cum_en);
    [~, s_index] = min(cum_en(h,2:(end-1)));
    s = zeros(h, 1); s(end) = s_index;
    for i = (h - 1):-1:1
        map = containers.Map(1:3,[s(i + 1) - 1, s(i + 1), s(i + 1) + 1]);
        if s(i + 1) >= w
            [~, tmp] = min([cum_en(i,s(i + 1) - 1), cum_en(i,s(i + 1))]);
        elseif s(i + 1) <= 1
            tmp = s(i + 1)+ 1;
        else
            [~, tmp] = min([cum_en(i,s(i + 1) - 1), cum_en(i,s(i + 1)), cum_en(i,s(i + 1)+ 1)]);
        end
        s(i) = map(tmp);
    end
%     size(s)
%     s = [s, (1:h)'];
end


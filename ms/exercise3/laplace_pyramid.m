function [ l_p ] = laplace_pyramid( I, l )
    l_p = gauss_pyramid(I, l);
    for i = 1:(l - 1)
        l_p{i} = l_p{i} - l_p{i + 1};
    end
end


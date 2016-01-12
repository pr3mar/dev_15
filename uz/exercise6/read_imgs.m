function [ imgs, dims ] = read_imgs( subdir )
    dir = 'faces';
    fname = '%.3d.png';
    tmp = imread(fullfile(dir,subdir,sprintf(fname, 1)));
    [h, w, c] = size(tmp); dims = [h, w, c];
    imgs = zeros(h * w * c, 64);
    for i = 1:64
        tmp = imread(fullfile(dir,subdir,sprintf(fname, i)));
        if (size(tmp,3) > 1)
            tmp = rgb2gray(tmp);
        end
        tmp = reshape(tmp, h * w, 1);
        imgs(:, i) = tmp;
    end
end


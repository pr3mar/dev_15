%read video
video = read_video('bigbuck');

% cropped video preallocated
new_video = uint8(zeros(100,100,3,size(video,4)));
vf = figure(1);

% set filter
f = fspecial('average' , 150);

% frame max diff
x_frames = zeros(size(video,4),1);
y_frames = zeros(size(video,4),1);

% difference between frames
for i = 1:size(video,4) - 1 
    set(0, 'CurrentFigure', vf);
    % get 2 consecutive frames and convert them to hsv color space
    tmp1 = rgb2hsv(video(:,:,:,i));
    tmp2 = rgb2hsv(video(:,:,:,i + 1));
    
    % get the difference and filter it
    dif = abs(tmp1(:,:,1) - tmp2(:,:,1));
    subplot(1,2,1); imagesc(dif); axis equal; axis tight;
    dif = imfilter(double(dif), f, 'corr');
    subplot(1,2,2); imagesc(dif); axis equal; axis tight;
    % find the maximum difference
    [mm, max_frame] = max(dif(:));
    [x_frames(i), y_frames(i)] = ind2sub(size(dif), max_frame);
    pause(0.001);
end

x_frames = smooth(x_frames);
y_frames = smooth(y_frames);
vf = figure(2);
for i = 1:size(x_frames)
    set(0, 'CurrentFigure', vf);
    left = x_frames(i);% - 49;
    right = x_frames(i)+ 99; % + 50;
    
    top = y_frames(i);% - 49;
    bottom = y_frames(i) + 99; % + 50;
    
    % crop the frame, x
    if (left < 1)
        right = right + abs(left) + 1;
        left = 1;
    end
    if(right > size(video,2))
        left = left - (right - size(video,1));
        right = size(video, 2);
    end
    
    % crop the frame, y
    if (top < 1)
        bottom = bottom + abs(top) + 1;
        top = 1;
    end
    if (bottom > size(video,1))
        top = top - (bottom - size(video,1));
        bottom = size(video, 1);
    end
    
    % difference between indices
    rl = right - left;
    bt = bottom - top;
    
    % copy the values
    new_video(:,:,:,i) = video(uint32(top:bottom), uint32(left:right), :, i);
    
    % display result
    subplot(1,2,1); imagesc(video(:,:,:,i));        axis tight; axis equal;
    subplot(1,2,2); imagesc(new_video(:,:,:,i));    axis tight; axis equal;
    imwrite(new_video(:,:,:,i), fullfile('centered',sprintf('%08d.jpg',i)));
    pause(0.001);
end
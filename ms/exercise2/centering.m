video = read_video('bigbuck');
vf = figure(1);
f = fspecial('average' , 100);
x_frames = zeros(1,size(video,4));
y_frames = zeros(1,size(video,4));
new_video = zeros(100,100,3,size(video,4));
size(new_video)
% difference between frames
for i = 1:size(video,4) - 1
    set(0, 'CurrentFigure', vf);
    tmp1 = rgb2hsv(video(:,:,:,i));
    tmp2 = rgb2hsv(video(:,:,:,i + 1));
    dif = abs(tmp1(:,:,1) - tmp2(:,:,1));
    dif = imfilter(double(dif), f, 'same');
    [mm, max_frame] = max(dif(:));
    [x_frames(i), y_frames(i)] = ind2sub(size(dif), max_frame);
    subplot(1,2,1);imagesc(video(:,:,:,i)); axis tight; axis equal;
    subplot(1,2,2);
    if (x_frames(i) - 50 < 1)
        left = 1;
        right = x_frames(i) + 49 + (x_frames(i) - 50);
    elseif(x_frames(i) + 49 > size(video,2))
        right = size(video, 1);
        left = x_frames(i) - 50 - (x_frames(i) + 49);
    else
        left = x_frames(i) - 50;
        right = x_frames(i) + 49;
    end;
    
    if (y_frames(i) - 50 < 1)
        top = 1;
        bottom = y_frames(i) + 49 + (y_frames(i) - 50);
    elseif (y_frames(i) + 49 > size(video,2))
        bottom = size(video, 2);
        top = y_frames(i) - 50 - (y_frames(i) + 49);
    else
        top = y_frames(i) - 50;
        bottom = y_frames(i) + 49;
    end
    rl = right - left
    bt = bottom - top
%     new_video(:,:,:,i) = video(left:right, top:bottom, :, i);
    imagesc(dif);
    axis tight; axis equal;
    pause(0.001);
end
clf;
% I = rgb2gray ( imread ( 'monitor.jpg' ) ) ;
% f = fspecial ( 'average' , 100) ; % create averaging f i l t e r
% R = imfilter ( double (I) , f , 'same' ) ; % f i l t e r the image
% imagesc (R) ;
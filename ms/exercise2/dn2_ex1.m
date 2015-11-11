% % (b)
% 
video = read_video('shaky');
% vf = figure(1);
% for i = 1:size(video,4)
%     set(0, 'CurrentFigure', vf);
%     imshow(video(:,:,:,i));
%     pause(0.01);
% end
% clf;

% % difference between frames
% for i = 1:size(video,4) - 1
%     set(0, 'CurrentFigure', vf);
%     imshowpair(video(:,:,:,i), video(:,:,:,i + 1), 'diff');
%     pause(0.05);
% end
% clf;
% % use darker areas because tehre is little or no difference between frames

% (c)
figure(1); clf; imshow(video(:,:,:,1)); 
[inX, inY] = ginput(1);
[x, y] = track_point(video, uint16(inX), uint16(inY), 30, 300);
figure(1); imshow(video(:,:,:,1)); hold on;
plot(x, y, 'MarkerSize', 2);
plot(x, y, 'r.', 'MarkerSize', 2);

% (d)
x = smooth(x);
y = smooth(y);
dx = x - inX;
dy = y - inY;
stabilized = uint8(zeros(size(video)));

% stabilized = imtranslate(video,[dx, dy]);
for i = 1:size(video,4)
    stabilized(:,:,:,i) = imtranslate(video(:,:,:,i),[dx(i), dy(i)]);
%     imwrite(stabilized(:,:,:,i), fullfile('smooth', sprintf('%08d.jpg', i)));
end

vf = figure(1);
for i = 1:size(stabilized,4)
    set(0, 'CurrentFigure', vf);
    imshow(stabilized(:,:,:,i));
    pause(0.01);
end
% % (b)
% 
video = read_video('shaky');
% vf = figure(1);
% for i = 1:size(video,4)
%     set(0, 'CurrentFigure', vf);
%     imshow(video(:,:,:,i));
%     pause(0.05);
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
 figure(1); imshow(video(:,:,:,1)); 
[inX, inY] = ginput(1);
[x, y] = track_point(video, 200, 140, 4, 10);

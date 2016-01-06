function demo_ar_video ()
    % DEMO_AR_VIDEO ()
    %
    % A wrapper script that performs the following steps:
    % 1. Loads the video.
    % 2. Loads calibration matrix K.
    % 3. Detects marker and its orientation in every image.
    % 4. Plots the result to figure 2.
    % 5. Saves the resulting image from figure 2 to a given folder.

    % Load calibration matrix
    K = construct_calibration_matrix('calibration/calibration_results.mat'); 

    % Load a template and reshape it into a 1-D vector
    marker_template = imread('template.png') ;
    marker_template = double( marker_template(:)' );

    % Set output folder
    output_images_folder = '/tmp/'; % Save output images here

    % Read vide and process all frames
    video_file = 'test_video.avi';

    video = VideoReader(video_file);
    frames = video.read();
    nFrames = size(frames, 4);

    for i = 1:nFrames,
        % Process a single image
        demo_ar_image(frames(:, :, :, i), K, marker_template);
    
        % Save image from figure 2 to disk
        figure(2); % Make figure 2 the current figure so we can save it
%         print('-djpeg', fullfile(output_images_folder, sprintf('%08d.jpg', i)));
    end
end

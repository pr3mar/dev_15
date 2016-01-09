function demo_ar_image (im, K, marker_template)
    % DEMO_AR_IMAGE (im, K, marker_template)
    %
    % Skeleton code that detects marker in the input image, and displays
    % the result. Modify this function to insert custom content on top
    % of detected marker!
    %
    % Input:
    %  - im: input image (RGB)
    %  - K: camera calibration matrix (3x3)
    %  - marker_template: marker template image, reshaped into 1-D column vector

    % Parameters
    thresh = 150;                       % luminance threshold
    areaMin = 1000;                     % marker must contain more contiguous black pixels than this
    cornerThresh = 7;                  % threshold for corner detection.
    debug_figure = 1;
    debug_palette = generate_palette();

    figure(2); clf;  %figure(1); clf;
    
    % Display input image
    im = double(im);
    draw_image(im, debug_figure);

    % Threshold image
    imThresh = threshold(im, thresh);
    draw_threshold(imThresh, debug_figure);

    % Find connected regions
    [ imConn,area, x, y,l,r,t, b ] = connected_components(imThresh, areaMin);
    draw_connected_components(imConn, debug_figure, debug_palette);

    % Find contours of regions
    [ imCont, YChain, XChain, chainL] = find_contours(imConn, t, r, l);
    draw_contours(imCont, debug_figure, debug_palette);

    % Fit straight lines to contours, and intersect them to find corners
    [ XChain, YChain, chainL, vertices ] = line_segments(XChain, YChain, chainL, area, cornerThresh);
    [ allPointsX, allPointsY ] = calculate_intersection(XChain, YChain, chainL, vertices);
    draw_corners_lines(im, allPointsX, allPointsY, debug_figure);

    % We assume that the correct marker is always at the first place in the 
    % list of detected markers - this is not always correct and could be 
    % made more robust!
    
    if ~isempty(allPointsX),
        allPointsX = allPointsX(1,:);
        allPointsY = allPointsY(1,:);
        
        % Identify which corner is which (i.e., determine the orientation)
        [ orientation, identity, vertex_order ] = match_orientation(imThresh, marker_template, allPointsX, allPointsY);
        
        % Coordinates of square marker in "world coordinates"
        X_world = [ 0, 1, 1, 0 ];
        Y_world = [ 0, 0, 1, 1 ];
        Z_world = [ 0, 0, 0, 0 ];
        
        % change the sequence of detected corners so that it matches the reference
        for i=1:size(vertex_order,1),
            if sum(vertex_order) > 0, % check if points exist
                allPointsX(i,:) = allPointsX(i,vertex_order(i,:));
                allPointsY(i,:) = allPointsY(i,vertex_order(i,:));
            end
        end
        
        % Now you have world coordinates of the marker in variables X_world
        % and Y_world (Z_world is 0 for all the points on the marker
        % plane), and corresponding image coordinates of the marker in
        % variables allPointsX and allPointsY, while vertex_order contains
        % the list of coordinate order
        
        H = estimate_homography(X_world, Y_world, allPointsX, allPointsY);
        
        lambda = 1/((norm(K \ H(:,1)) + norm(K \ H(:,2)))/2);
        
        B = K \ H;
        if (det(B) < 0)
            B = B * (-1);
        end
        
        B = lambda * B;
        
        r1 = B(:,1);
        r2 = B(:,2);
        r3 = cross(r1, r2);
        R = [r1 r2 r3];
        t = B(:,3);
        
        P = K * [R t];
        %               1 2 3 4  5  6  7  8 9
        circle_world = [0 1 1 0  0  1  1  0 0; ...
                        0 0 1 1  0  0  1  1 0; ...
                        0 0 0 0 -0.75 -0.75 -0.75 -0.75 1; ...
                        1 1 1 1  1  1  1  1 1];
        circle_color = [ 0   0 0; ... % black
                         1   1 0; ... % yellow
                         0   1 0; ... % magenta
                         0   1 1; ... % cyan
                         1   0 0; ... % red
                         1 0.5 0; ... % orange
                         0   0 1; ... % blue
                         1   1 1]; % white
        line_pairs = [1 2; ...
                      1 4; ...
                      1 5; ...
                      2 3; ...
                      2 6; ...
                      3 4; ...
                      3 7; ...
                      4 8; ...
                      5 6; ...
                      5 8; ...
                      6 7; ...
                      7 8];
%         tmp = circle_world(1:2,:) + 0.05;
%         circle_world(1:2,:) = tmp;
        circ_dim = [15 15];
        
        figure(2); imagesc(uint8(im)); axis tight; axis equal; hold on;
        circle_camera = P * circle_world;
        circle_camera = bsxfun (@rdivide, circle_camera, circle_camera(end,:));
        draw = [circle_camera(1:2, 1:(end -1))', repmat(circ_dim, 8, 1)];
        
        for i = 1:size(line_pairs,1)
            index1 = line_pairs(i,1);
            index2 = line_pairs(i,2);
            x1 = circle_camera(1, index1);
            x2 = circle_camera(1, index2);
            y1 = circle_camera(2, index1);
            y2 = circle_camera(2, index2);
            
            plot([x1, x2], [y1, y2], 'Color', [1 0 1], 'LineWidth', 2);
        end
        
        plot([circle_camera(1, 1), circle_camera(1, 2)], [circle_camera(2,1), circle_camera(2, 2)], 'r', 'LineWidth', 2); % x axis
        plot([circle_camera(1, 1), circle_camera(1, 4)], [circle_camera(2,1), circle_camera(2, 4)], 'g', 'LineWidth', 2); % y axis
        plot([circle_camera(1, 1), circle_camera(1, 9)], [circle_camera(2,1), circle_camera(2, 9)], 'b', 'LineWidth', 2); % y axis
        
        for i = 1:(size(draw,1))
%             rectangle('Position',draw(i,:) ,'Curvature',[1 1], 'FaceColor',[0 .5 .5], 'EdgeColor',[0 .5 .5])
            filledCircle(draw(i,1:2),10,500, circle_color(i,:));
        end
        draw;
    else
        figure(2); clf;
        imagesc(uint8(im)); hold on; axis equal; axis tight;
    end

    hold off;
end

%-------------------------- Utility code for visualization ---------------- %
function draw_image(im, h1)
%     figure(h1); set(gcf,'Position',[ 61   206   944   467]);
    figure (h1); subplot(2,3,1); imagesc(im/255); axis off; pause(0.01);
    title('Original Image');
end

function draw_threshold(imThresh, h1)
    figure (h1); subplot(2,3,2); imagesc(imThresh); colormap(gray); axis off; pause(0.01);
    title('Thresholded Image');
end

function draw_connected_components(imConn, h1, palette)
    figure(h1); subplot(2,3,3); imagesc(imConn); colormap(palette);axis off;
    title ('Connected Components');
end

function draw_contours (imCont, h1, palette)
    figure(h1);subplot(2,3,4);imagesc(imCont); colormap(palette);axis off;
    title ('Contours');
end

function draw_corners_lines(im, allPointsX, allPointsY, h1)
    figure(h1);subplot(2,3,5);
    imagesc(im/255);axis off;hold on;
    [noObjects, dummy] = size(allPointsX);

    for object = 1:noObjects
        for thisVertex = 1:4 
            c1 = thisVertex;
            c2 = rem(thisVertex,4)+1;
            plot ([allPointsX(object,c1) allPointsX(object,c2)],[allPointsY(object,c1), allPointsY(object,c2)],'yo-','MarkerSize',6,'MarkerFaceColor','b','MarkerEdgeColor','w','LineWidth',3);
            set(gca,'YDir','reverse');                  
        end;
    end;
    [imY, imX] = size(im);
    xlim([0 imX/3]);ylim([0 imY]); 
    title('Extracted Marker Edges and Corners');
end
 
function debug_palette = generate_palette()

    debug_palette = colormap;
    for c1 = 1:20
        debug_palette((c1-1)*10+1,:) = [0 0.5 0];   
        debug_palette((c1-1)*10+2,:) = [0 1 0];
        debug_palette((c1-1)*10+3,:) = [1 0 0];
        debug_palette((c1-1)*10+4,:) = [0 0 1];
        debug_palette((c1-1)*10+5,:) = [1 0 1];
        debug_palette((c1-1)*10+6,:) = [1 1 0];
        debug_palette((c1-1)*10+7,:) = [0 1 1];
        debug_palette((c1-1)*10+8,:) = [0.5 0 0];
        debug_palette((c1-1)*10+9,:) = [0 0 0.5];
        debug_palette((c1-1)*10+10,:) = [1 1 1];
    end;
    debug_palette(1,:) = [0 0 0];

end


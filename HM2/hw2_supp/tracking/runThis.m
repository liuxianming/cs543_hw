%% Demo for CS543 - Computer Vision, Homework 2 - Problem 1
% This demo includes two parts:
% 1. Harris corner point detection
% 2. KLT tracking based on Harris detector

IMG_DIR = './images/';
sigma = 7; % The window size used in KLT tracking
N_PT = 20; % Number of points tracked in KLT demo
IMG_COUNT = 50; % count of images need to track, besides seq0.png
KLT_DISP_HANDLE = 1;
FN_PREFIX = 'hotel.seq';

% Part1: Harris Detector:
disp('***************************************************');
disp('Problem 2-1-1: Harris Corner Detection. Please press any key to continue.')
disp('***************************************************');
im = imread(fullfile(IMG_DIR, [FN_PREFIX,'0.png']));

[keyxs, keyys] = getKeypoints(im, 0.025);
pts_num = length(keyxs);

figure(KLT_DISP_HANDLE);
subplot(2,2,1);
imshow(im);
hold on;
plot(keyxs, keyys, 'g+', 'linewidth',3);
% scatter(keyxs, keyys, 20, 'g');
title('CS543 Homework 2-1-1: Harris Corner Point Extraction');
pause();

% Part2: KLT tracking
% First sampling points
disp('***************************************************');
disp('Problem 2-1-2: KLT Tracking')
disp('***************************************************');
harris_count = length(keyxs);
startXs = keyxs;
startYs = keyys;
lost_pts = zeros(harris_count,1);
trajectoryX = zeros(harris_count, IMG_COUNT+1);
trajectoryY = zeros(harris_count, IMG_COUNT+1);
trajectoryX(:,1) = startXs;
trajectoryY(:,1) = startYs;

% Performing Tracking: Track all the points
disp('Starting Tracking');
for i = 1:IMG_COUNT
    im0_fn = fullfile(IMG_DIR, [FN_PREFIX, sprintf('%d.png',i-1)]);
    im1_fn = fullfile(IMG_DIR,[FN_PREFIX, sprintf('%d.png',i)]);
    % log
    fprintf(1,'Tracking From FRAME # %d -> #%d:\n',i-1, i);
    im0 = im2double(imread(im0_fn));
    im1 = im2double(imread(im1_fn));
    [newXs, newYs]= predictTranslationAll(startXs, startYs, im0, im1, sigma);
    % Plot 
    lost_pts = lost_pts | (newXs == 0);
    % Assign startXs, startYs
    startXs = newXs;
    startYs = newYs;
    trajectoryX(:,i+1) = startXs;
    trajectoryY(:,i+1) = startYs;
end

disp('Tracking Complete');
% Sampling points and output the trajectory
disp('Randomly Choosing Points');
valid_pts = find(1-lost_pts);
rand_idx = randi([1,length(valid_pts)],1,N_PT); % Using function randi to generate random ints
rand_idx = valid_pts(rand_idx);

selected_keyxs = keyxs(rand_idx);
selected_keyys = keyys(rand_idx);
% Print the sampling information to the screen
disp('Sampled Points:');
for i = 1:length(rand_idx)
    fprintf(1,'[%d, %d], ',selected_keyxs(i), selected_keyys(i));
end
fprintf(1,'\n');

% Plotting sampled trajectory
subplot(2,2,2);
imshow(im); hold on; 
for i = 1:IMG_COUNT+1
    xs = trajectoryX(rand_idx,i);
    ys = trajectoryY(rand_idx,i);
    plot(xs, ys, 'g+', 'linewidth', 3);
end
title('KLT Tracking for sampled Harris Keypoints');

% Plot final frame
subplot(2,2,3);
imshow(im1); hold on;
plot(xs, ys, 'ro','linewidth', 3);
title('Tracked Points located on the last frame');

% Plot the lost points
subplot(2,2,4);
imshow(im); hold on;
for i=1:IMG_COUNT+1
    xs = trajectoryX(lost_pts,i);
    ys = trajectoryY(lost_pts,i);
    % filtered out those who are 0s
    ptr_idxs = (xs>0) & (ys>0);
    plot(xs(ptr_idxs),ys(ptr_idxs), 'r+', 'linewidth',3); 
end
title('KLT Tracking for points moved out of frame at some time');

%% CS 543 Computer Vision Homework 4 - Problem 1: SLIC Superpixels
%---------------------------------------------------------------------
% (b) Choose one image, try three different weights 
% on the color and spatial feature and show the three segamentation results
%---------------------------------------------------------------------
disp('(b)Show segmentation results on different weights');
img = imread('lion.jpg');
K = 256;
compactness = [10, 25, 50];
figure(1);
for i = 1:3
    [cIndMap, time, imgVis] = slic(img, K, compactness(i));
    subplot(1,3,i);
    imshow(imgVis,[]);
    titlestr = sprintf('Segmenation for weight = %d',compactness(i));
    title(titlestr);
end
drawnow;

%---------------------------------------------------------------------
% (c) Choose one image, show the error map 
%       (1) at the initialization and 
%       (2) at convergence.
%---------------------------------------------------------------------
disp('(c)Choose one image, show the error map (1) at the initialization and (2) at convergence');
img = imread('house2.jpg');
[cIndMap, time, imgVis] = slic(img, K, 25, 2);

%---------------------------------------------------------------------
% (d) Choose one image, show three superpixel results with different K
%       K = [36, 100, 256] respectively
%---------------------------------------------------------------------
disp('(d) Choose one image, show three superpixel results with different K');
img = imread('lion.jpg');
K = [36, 100, 256];
time = [0 0 0];
figure(3);
for i = 1:3
    [cIndMap, time(i), imgVis] = slic(img, K(i), 50);
    subplot(1,3,i);
    imshow(imgVis,[]);
    titlestr = sprintf('Segmenation for K = %d',K(i));
    title(titlestr);
    time_str = sprintf('Time cost when [K=%d] = %s', K(i), time(i));
    disp(time_str);
end
drawnow;

%---------------------------------------------------------------------
% (e) Run Benchmark Evaluation
%---------------------------------------------------------------------
evalSLIC
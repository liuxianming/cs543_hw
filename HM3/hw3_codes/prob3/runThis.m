%% Computer Vision Homework 3: Problem 3 - Epipolar geometry
% ----------------------------------------- %
% 1. plot the outliers;
% Use points in prob3.mat 
% and Plot the outliers with green dots on top of the first image
% ----------------------------------------- %
load('prob3.mat');
im1 = imread('chapel00.png');
im2 = imread('chapel01.png');
[F,inliers,outliers] = ransacFundMatrix(matches,c1,r1,c2,r2,2,5000);
h=plotmatches(im1,im2,[c1 r1]',[c2 r2]',matches(outliers,:)');
n_outlier = sum(outliers);
fprintf(1, 'The number of outliers is %d\n', n_outlier);
% begin plotting on im1
X_outlier = c1(matches(outliers,1));
Y_outlier = r1(matches(outliers,1));
figure,imshow(im1),hold on;
plot(X_outlier,Y_outlier,'g.','linewidth',4),hold off;
title('Outliers detected using RANSAC');

% ----------------------------------------- %
% 2. plot the epipolar lines of 7 set of matching points
% ----------------------------------------- %
% using randperm to randomly choose matched points
% Use the first 7 random pairs
rand_inliers = randperm(sum(inliers));
tempIdx = find(inliers>0);
idx = matches(tempIdx(rand_inliers(1:7)),:);
x1 = c1(idx(:,1));
y1 = r1(idx(:,1));
x2 = c2(idx(:,2));
y2 = r2(idx(:,2));

figure;title('Epipolar lines based on randomly selected 7 matched pairs');
subplot(1,2,1),imshow(im1),hold on;
for i = 1:7
    param1 = F'*[x2(i);y2(i);1];
    x = 1:size(im1,2);
    plot(x1(i),y1(i),'r+','linewidth',1),hold on;
    plot(x,(-param1(1)/param1(2)).*x - param1(3)/param1(2),'g'),hold on;
end
subplot(1,2,2),imshow(im2), hold on;
for i = 1:7
    param2 = F*[x1(i);y1(i);1];
    x = 1:size(im1,2);
    plot(x2(i),y2(i),'r+','linewidth',1),hold on;
    plot(x,(-param2(1)/param2(2)).*x - param2(3)/param2(2),'g'),hold on;
end
hold off;
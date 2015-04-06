%% Computer Vision Homework 3: Problem 4
% ----------------------------------------- %
% Affine Structural from Motion
% The implementation of tracking is in asm.m
% ----------------------------------------- %

load('tracked_points.mat');
[K,X,A] = asm(Xs,Ys);
figure, plot3(X(1,:),X(2,:),X(3,:),'r.');
title('3D locations of the tracked points')

figure, subplot(1,3,1), plot(K(:,1));
subplot(1,3,2), plot(K(:,2)); title('Predicted 3D path of the cameras')
subplot(1,3,3), plot(K(:,3));
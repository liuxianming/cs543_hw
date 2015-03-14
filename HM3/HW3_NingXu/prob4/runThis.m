load('tracked_points.mat');
[K,X,A] = ASM(Xs,Ys);
figure, plot3(X(1,:),X(2,:),X(3,:),'r.');

figure, subplot(1,3,1), plot(K(:,1));
subplot(1,3,2), plot(K(:,2));
subplot(1,3,3), plot(K(:,3));
clear all;
%%
load('trackedX.mat');
load('trackedY.mat');
cd('images');
im = imread('hotel.seq0.png');
%%
cd('..');
[newX newY] = MissingMatrixCompletion(X,Y);
figure, imshow(im), axis([-50,size(im,2)+10,-10,size(im,1)+50]), hold on;
X1 = X(:,X(3,:)>0);
Y1 = Y(:,X(3,:)>0);
idx = find(Y1(end,:)==0);

for i = 1:size(idx,2)
    plot(newX(:,idx(i)), newY(:,idx(i)),'r-','linewidth',2), hold on;
end
hold off;
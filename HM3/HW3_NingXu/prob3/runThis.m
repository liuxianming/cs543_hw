%% plot the outliers;
load('prob3.mat');
im1 = imread('chapel00.png');
im2 = imread('chapel01.png');
[F,inliers,outliers] = ransacFundMatrix(matches,c1,r1,c2,r2,2,5000);
h=plotmatches(im1,im2,[c1 r1]',[c2 r2]',matches(outliers,:)')
count = sum(outliers)
outX1 = c1(matches(outliers,1));
outY1 = r1(matches(outliers,1));
figure,imshow(im1),hold on;
plot(outX1,outY1,'g.','linewidth',4),hold off;
%% plot the 7 set of matching points
temp = randperm(sum(inliers));
tempIdx = find(inliers>0);
idx = matches(tempIdx(temp(1:7)),:);
x1 = c1(idx(:,1));
y1 = r1(idx(:,1));
x2 = c2(idx(:,2));
y2 = r2(idx(:,2));

figure,subplot(1,2,1),imshow(im1),hold on;
for i = 1:7
    param1 = F'*[x2(i);y2(i);1];
%     x = x2(i)-70:x2(i)+10;
    x = 1:size(im1,2);
    plot(x1(i),y1(i),'r+','linewidth',1),hold on;
    plot(x,(-param1(1)/param1(2)).*x - param1(3)/param1(2),'g'),hold on;
end
subplot(1,2,2),imshow(im2), hold on;
for i = 1:7
    param2 = F*[x1(i);y1(i);1];
%     x = x1(i)-10:x1(i)+70;
    x = 1:size(im1,2);
    plot(x2(i),y2(i),'r+','linewidth',1),hold on;
    plot(x,(-param2(1)/param2(2)).*x - param2(3)/param2(2),'g'),hold on;
end
hold off;
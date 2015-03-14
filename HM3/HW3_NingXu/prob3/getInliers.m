function [inliers,outliers] = getInliers(F,matches,c1,r1,c2,r2,eps)
x1 = c1(matches(:,1));
y1 = r1(matches(:,1));
x2 = c2(matches(:,2));
y2 = r2(matches(:,2));

param2 = F*[x1';y1';ones(1,size(x1,1))];
norm2 = sqrt(param2(1,:).^2 + param2(2,:).^2);
param1 = F'*[x2';y2';ones(1,size(x2,1))];
norm1 = sqrt(param1(1,:).^2 + param1(2,:).^2);
dist1 = abs(sum([x1';y1';ones(1,size(x1,1))].*param1))./norm1;
dist2 = abs(sum([x2';y2';ones(1,size(x2,1))].*param2))./norm2;

idxTemp1 = dist1 < eps;
idxTemp2 = dist2 < eps;
inliers = (idxTemp1 & idxTemp2);
outliers = ~inliers;

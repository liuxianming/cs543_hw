function [F,inliers,outliers] = ransacFundMatrix(matches,c1,r1,c2,r2,eps,N)
% Running RANSAC to find inliers and outliers

count = 0;
for i = 1:N
    % randomly permute points
    pmatches = randperm(size(matches,1));
    idx = matches(pmatches(1:16),:);
    F = fundMatrix(idx,c1,r1,c2,r2);
    [inliers,outliers] = getInliers(F,matches,c1,r1,c2,r2,eps);
    if (sum(inliers)>count)
        itrinliers = inliers;
        count = sum(inliers);
    end
end

matchIdx = matches(itrinliers,:);
F = fundMatrix(matchIdx,c1,r1,c2,r2);
[inliers,outliers] = getInliers(F,matches,c1,r1,c2,r2,eps);

end
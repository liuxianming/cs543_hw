function [newXs, newYs] = predictTranslationAll(startXs, startYs, im0, im1, sigma)
%PREDICTTRANSLATIONALL ComputenewX,Y locations for all starting locations.
%   This function will calculate spatial gradient Ix, Iy
%   And call predictTranslation() function to complete the whole process
%   Input:
%   - startXs, startYs: the sampled points to track
%   - im0, im1: image frame at t and t+1
%   - sigma: the radius of window to track

if nargin<5
    sigma = 7;
end

% Calculate gradients
[Ix, Iy] = imgradientxy(im0, 'prewitt');

n_points = length(startXs);
newXs = startXs;
newYs = startYs;

for i = 1:n_points
    % Process each point
    startX = startXs(i);
    startY = startYs(i);
    %log:
    fprintf(1,'Tracking Point [%d, %d]', startX, startY);
    Ix_patch = Ix(startX-sigma:startX+sigma, startY-sigma:startY+sigma);
    Iy_patch = Iy(startX-sigma:startX+sigma, startY-sigma:startY+sigma);
    P = predictTranslation(startX, startY, Ix_patch, Iy_patch, im0, im1, sigma);
    newXs(i) = P(1); newYs(i) = P(2);
    fprintf(1,'-> [%.2f, %.2f]\n', P(1), P(2));
end

end


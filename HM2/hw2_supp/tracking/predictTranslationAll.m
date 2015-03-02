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
[Ix, Iy] = gradient(im0);

n_points = length(startXs);
newXs = startXs;
newYs = startYs;

for i = 1:n_points
    % Process each point
    startX = startXs(i);
    startY = startYs(i);
    if (startX-sigma)<=0 || (startX+sigma)>size(im0,2) || (startY-sigma)<=0 || (startY+sigma)>size(im0,1)
        P = [0,0]';
        % log
        fprintf(1,'Point [%.2f, %.2f] Lost - Out of image range', startX, startY);
    else
        % log:
        fprintf(1,'Tracking Point [%.2f, %.2f]', startX, startY);
        % In case of input points are not integer, use interp2
        [x, y] = meshgrid(startX-sigma:startX+sigma, startY-sigma:startY+sigma);
        Ix_patch = interp2(Ix, x, y, '*linear');
        Iy_patch = interp2(Iy, x, y, '*linear');
        P = predictTranslation(startX, startY, Ix_patch, Iy_patch, im0, im1, sigma);
        fprintf(1,'-> [%.2f, %.2f]\n', P(1), P(2));
    end
    newXs(i) = P(1); newYs(i) = P(2);
end

end


function [mag, theta] = gradientMagnitude(im, sigma)
%This function should take an RGB image as input, 
% smooth the image with Gaussian std=sigma, 
% compute the x and y gradient values of the smoothed image, 
% and output image maps of the gradient magnitude and orientation at each pixel.

fsize = ceil(8*sigma);
g_filter = fspecial('gaussian',fsize, sigma);
im = imfilter(im, g_filter, 'same');

% calculate x and y directional gradient
GX_filter = [1, 0, -1];
GY_filter = [1, 0, -1]';

GX = imfilter(im, GX_filter);
GY = imfilter(im, GY_filter);

gradmags = sqrt(GX.^2 + GY.^2);
mag = sqrt(gradmags(:,:,1).^2 + gradmags(:,:,2).^2 + gradmags(:,:,3).^2);

sintheta = GX ./ gradmags;
costheta = GY ./ gradmags;

thetas = atan(sintheta ./ costheta);
thetas = thetas + (pi .* sign(sintheta)) .* (costheta<0);

% Choose the direction with largest gradient mag
[~, maxidx] = max(gradmags, [], 3);
theta = zeros(size(thetas, 1), size(thetas, 2));
for i = 1:3
    theta = theta + thetas(:,:,i) .* (maxidx == i);
end

end


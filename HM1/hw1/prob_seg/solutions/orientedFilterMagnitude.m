function [mag,theta] = orientedFilterMagnitude(im, NSCALE)
%Computes the boundary magnitude and orientation using a set of oriented filters
% One way to combine filter responses is 
% to compute a boundary score for each filter (simply by filtering with it) 
% and then use the max and argmax over filter responses 
% to compute the magnitude and orientation for each pixel.

% Parameters: three scales, and six orientations, 
% which results totally 18 filters

if(ndims(im) == 3)
    im = rgb2gray(im);
end

if nargin < 2
    NSCALE = 1; % base filter scale is sqrt(2)
end

NORIENT=6; 

scales = 3 * sqrt(2) .^ [0:NSCALE-1];
thetas = linspace(0,pi, NORIENT+1);
thetas = thetas(1:end-1);

sfilters = steerablefilter( scales, thetas );

mags = zeros(size(im,1), size(im,2), NSCALE * NORIENT);
for i = 1:NSCALE * NORIENT
    f = sfilters{i};
    scale_normalizer = sqrt(scales(ceil(i/NORIENT)));
    mags(:,:,i) = imfilter(im, f, 'conv', 'replicate') * scale_normalizer;
end

theta=zeros(size(im));
[mag, magidx] = max(mags, [], 3);
for orientidx = 1:NORIENT * NSCALE
    orientation = thetas(mod(orientidx - 1, NORIENT) + 1);
    theta = theta + orientation * (magidx == orientidx);
end

end


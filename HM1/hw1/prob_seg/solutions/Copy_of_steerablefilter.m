function [ responses ] = steerablefilter( im, scale, thetas )
%STEERABLEFILTER 
% convolve input image with steerable filters
% Input:
%   - im - input image, gray level and double
%   - scale - scale factors
%   - thetas - angles, in arc

nresponse = length(scale) * length(thetas);
responses = zeros(size(im, 1), size(im, 2), nresponse);

for sidx = 1:length(scale)
    sigma = scale(sidx);
    [x,y]   = ndgrid(-round(3*sigma):round(3*sigma));
    G = exp(-(x.^2+y.^2)/(2*sigma^2))/(2*pi*sigma);
    % Generate gx, gy, and normalize
    Gx = -x.*G/(sigma^2);Gx = Gx/sum(Gx(:));
    Gy = -y.*G/(sigma^2);Gy = Gy/sum(Gy(:));
    
    Rx = imfilter(im, Gx, 'conv', 'replicate');
    Ry = imfilter(im, Gy, 'conv', 'replicate');
    
    for tidx = 1:length(thetas)
        ridx = (sidx-1) * length(thetas) + tidx;
        responses(:,:, ridx) = cos(thetas(tidx)) * Rx + sin(thetas(tidx)) * Ry;
    end
end


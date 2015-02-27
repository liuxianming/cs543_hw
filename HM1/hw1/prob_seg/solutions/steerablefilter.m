function [ sfilters ] = steerablefilter( scale, thetas )
%STEERABLEFILTER 
% convolve input image with steerable filters
% Input:
%   - im - input image, gray level and double
%   - scale - scale factors
%   - thetas - angles, in arc

nresponse = length(scale) * length(thetas);
sfilters = {};

for sidx = 1:length(scale)
    sigma = scale(sidx);
    [x,y]   = ndgrid(-round(4*sigma):round(4*sigma));
    G = exp(-(x.^2+y.^2)/(2*sigma^2))/(2*pi*sigma);
    % Generate gx, gy, and normalize
    Gx = -x.*G/(sigma^2);Gx = Gx/sum(Gx(:));
    Gy = -y.*G/(sigma^2);Gy = Gy/sum(Gy(:));
    
    for tidx = 1:length(thetas)
        sfilters{end+1} = cos(thetas(tidx)) * Gx + sin(thetas(tidx)) * Gy;
    end
end


function [keyXs, keyYs] = getKeypoints(im, tau, k, sigma)
%GETKEYPOINTS Get keypoints from im, using Harris detector
%   Input:
%   - im: image
%   - tau: threshold
% In my implementation, I use Gaussian to smooth the Harris window

if nargin < 2
    error "Error: parameter number must be larger than 2";
    return
end
if nargin < 3
    k = 0.02;
end
if nargin < 4
    sigma = 1;
end

if ndims(im) == 3
    im = rgb2gray(im);
end

im = im2double(im);

% Calculate the gradient
dx = fspecial('sobel');
dy = dx';
    
Ix = conv2(im, dx, 'same');    % Image derivatives
Iy = conv2(im, dy, 'same');  

Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

if sigma <= 0 
    sigma = 1;
    printf(0, 'Sigma can not be 0. Default value 1 is used');
end

% Convolution
fsize = floor(3*sigma);
gfilter = fspecial('gaussian', [2*fsize+1, 2*fsize+1], sigma);

Ix2 = imfilter(Ix2, gfilter, 'same');
Iy2 = imfilter(Iy2, gfilter, 'same');
Ixy = imfilter(Ixy, gfilter, 'same');

% R = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
R = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);

% Perform non-maxima suppression over a 5*5 window
radius = 5; 
wsize = 2*radius+1;                     
mx = ordfilt2(R,wsize^2,ones(wsize));

% Dealing with boundary conditions
boarderMask = zeros(size(R));
boarderMask(wsize - 1:end - wsize + 1, wsize - 1:end - wsize + 1) = 1;

rim = (R==mx)&(R>tau)&boarderMask; 
	
[keyYs, keyXs] = find(rim);

end


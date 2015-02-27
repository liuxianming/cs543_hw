function bmap = edgeGradient( im )
%This function should use gradientMagnitude 
% to compute a soft boundary map 
% and then perform non-maxima suppression.

sigma = 1;
[mag, theta] = gradientMagnitude(im, sigma);
%subplot(1,2,1); imagesc(mag); colormap gray;

mag = nonmax(mag, theta);
%subplot(1,2,2); imagesc(mag); colormap gray;

bmap = mag.^ 0.7;
% Normalization:
bmap = bmap ./ max(max(bmap));

end


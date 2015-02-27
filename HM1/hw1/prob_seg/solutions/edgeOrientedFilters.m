function bmap= edgeOrientedFilters(im, NSCALE)

if nargin < 2
    NSCALE = 1;
end
[mag,theta] = orientedFilterMagnitude(im, NSCALE);
canny_edge = edge(rgb2gray(im), 'canny',[], 2);
mag = mag .* (canny_edge > 0);
%mag = nonmax(mag, theta);

%bmap = abs(mag).^0.7;
bmap = abs(mag);
% Normalization:
bmap = bmap / max(max(bmap));

end


function dispim = displayAlignment(im1, im2, aligned1, thick)
% dispim = displayAlignment(im1, im2, aligned1)
% Displays the alignment of im1 to im2
%    im1: first input image to alignment algorithm (im1(y, x)=1 if (y, x)
%    is an original point in the first image)
%    im2: second input image to alignment algorithm
%    aligned1: new1(y, x) = 1 iff (y, x) is a rounded transformed point from the first time 
%    thick: true if a line should be thickened for display

if ~exist('thick', 'var')
  thick = false;
end

% for thick lines (looks better for final display)
if thick
  dispim = cat(3, ordfilt2(im1, 9, ones(3)), ordfilt2(aligned1, 9, ones(3)), ordfilt2(im2, 9, ones(3)));
else
  % for thin lines (faster)
  dispim = cat(3, im1, aligned1, im2);
end
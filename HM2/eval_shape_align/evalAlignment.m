function err = evalAlignment(aligned1, im2)
% err = evalAlignment(aligned1, im2)
%
% Computes the error of the aligned image (aligned1) and im2, as the
% average of the average minimum distance of a point in aligned1 to a point in im2
% and the average minimum distance of a point in im2 to aligned1.

d2 = bwdist(im2); %distance transform
err1 = mean(d2(logical(aligned1)));
d1 = bwdist(aligned1);
err2 = mean(d1(logical(im2)));
err = (err1+err2)/2;

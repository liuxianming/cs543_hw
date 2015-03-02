im = imread('./images/hotel.seq0.png');

[keyxs, keyys] = getKeypoints(im, 0.025);
pts_num = length(keyxs);

figure();
imagesc(im);colormap gray;
hold on;

plot(keyys, keyxs, 'g+', 'linewidth',3);
title('Harris Corner Point Extraction: Frame hotel.seq0.png');
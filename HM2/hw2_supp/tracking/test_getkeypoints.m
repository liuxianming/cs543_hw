im = imread('./images/hotel.seq0.png');

[keyxs, keyys] = getKeypoints(im, 0.005);
pts_num = length(keyxs);

figure();
imagesc(im);colormap gray;
hold on;

plot(keyxs, keyys, 'g+', 'linewidth',3);
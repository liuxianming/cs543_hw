im0 = im2double(imread('./images/hotel.seq23.png'));
im1 = im2double(imread('./images/hotel.seq24.png'));

[keyxs, keyys] = getKeypoints(im0, 0.025);

% Pick start point
startX = keyxs(5);
startY = keyys(5);
sigma = 7;

[Ix, Iy] = imgradientxy(im0, 'prewitt');

Ix = Ix(startX-sigma:startX+sigma, startY-sigma:startY+sigma);
Iy = Iy(startX-sigma:startX+sigma, startY-sigma:startY+sigma);

% Tracking
P = predictTranslation(startX, startY, Ix, Iy, im0, im1, sigma);

% Ploting
figure(3);
subplot(1,2,1); 
imshow(im0); hold on; plot(startY, startX, 'g+', 'linewidth',3);
title('Seq0 and Keypoint'); 
%
subplot(1,2,2);  
imshow(im1); hold on; plot(P(2), P(1), 'g+', 'linewidth',3);
title('Seq1 and Tracked Keypoint');

distance = norm(P - [startX, startY]');
fprintf(1, 'Distance moved = %.2f\n', distance);


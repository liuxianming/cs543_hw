function [gaussian_pyramid, laplacian_pyramid] = gaussian_pyramids(img, levels, sigma, hsize)

%Parameters:
if nargin < 4
    hsize = [5,5];
end
if nargin < 3
    sigma = 2;
end

% Creat size arrays
wlevels = [size(img, 1)];
hlevels = [size(img, 2)];
for i = 2:levels
    wlevels(end+1) = floor(wlevels(end) / 2);
    hlevels(end+1) = floor(hlevels(end) / 2);
end

% Creat Gaussian Filter
G = fspecial('gaussian',hsize, sigma);

gaussian_pyramid = {img};
laplacian_pyramid = {};

for idx = 1:(levels - 1)
    cimg = gaussian_pyramid{end};
    gimg = imfilter(cimg, G, 'same');
    gimg = imresize(gimg, [wlevels(idx+1), hlevels(idx+1)]);
    gaussian_pyramid{end+1} = gimg;
    
    % Calucate laplacians
    laplacian_img = cimg - imresize(gimg, [wlevels(idx), hlevels(idx)]);
    laplacian_pyramid{end + 1} = laplacian_img;
end
laplacian_pyramid{end+1} = gaussian_pyramid{end};

% Show Gaussian and Laplacian Pyramid
ha = tight_subplot(2,5,[.01 .03],[.1 .01],[.01 .01]);
for figidx = 1:levels
    gaussian_fig_idx = figidx;
    laplacian_fig_idx = figidx+levels;
    axes(ha(gaussian_fig_idx)); imshow(gaussian_pyramid{figidx} * 255);
    axes(ha(laplacian_fig_idx)); imagesc(laplacian_pyramid{figidx}); colormap gray;
end

% Plot the frequence of Gaussian / Laplacian Pyramids: using FFT2
figure(2);
hb = tight_subplot(2,5,[.01 .03],[.1 .01],[.01 .01]);
for figidx = 1:levels
    gaussian_fig_idx = figidx;
    laplacian_fig_idx = figidx+levels;
    % Resize to original size to keep spectrums comparable
    g_pyramid_img = imresize(gaussian_pyramid{figidx}, [wlevels(1), hlevels(1)]);
    l_pyramid_img = imresize(laplacian_pyramid{figidx}, [wlevels(1), hlevels(1)]);
    % Performing fft and calculate the magnitute
    FG = fft2(g_pyramid_img); FG = fftshift(FG);
    FL = fft2(l_pyramid_img); FL = fftshift(FL);
    axes(hb(gaussian_fig_idx)); colormap gray; imagesc(log(abs(FG)));
    axes(hb(laplacian_fig_idx)); colormap gray; imagesc(log(abs(FL)));
end
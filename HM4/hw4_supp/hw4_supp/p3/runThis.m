function runThis()
%% Code for CS 543 Homework 4,gch = GraphCut('open', Dc, 10*Sc, Problem 3 - Graph Cut Segmentation
%
%----------------------------------------------------------------
close all;
addpath('./GCmex1.5/')

disp('Reading Image');
im = im2double(imread('cat.jpg'));
sz = size(im);
data = reshape(im, [sz(1) * sz(2), sz(3)]);

disp('Reading Polygon and Generating FG masks');
load('cat_poly.mat');
mask = poly2mask(poly(:,1), poly(:,2), sz(1), sz(2));

K=2; %segment the image into K parts, 2: foreground and background
k1 = 1;
k2 = 1;
num_gmm = 5; % use 2 gaussian to estimate the foreground

SEG_ITER = 2; % Number of iterations: estimate posibility -> graph cut

% Prepare data: Smoothness
Sc=ones(K) - eye(K); 
% Calculate edge response
[Hc, Vc] = edge_potential(im);

disp('Start Graph Cut...');
for iter = 1:SEG_ITER
    fprintf(1,'Performing Iteration %d...\n', iter);
    % estimate GMM
    fg = data(mask(:), :);
    bg = data(~mask(:),:);
    % estimate gmm model
    fg_gmm = fitgmdist(fg, num_gmm);
    bg_gmm = fitgmdist(bg, num_gmm);
    % calculate the foreground probability
    p_fg = fg_gmm.pdf(data);
    p_fg = reshape(p_fg, sz(1), sz(2));
    p_bg = bg_gmm.pdf(data);
    p_bg = reshape(p_bg, sz(1), sz(2));
    
    figure(1);
    subplot(1,3,1); imagesc(p_fg, [0,1]); title('Foreground Intensity');
    subplot(1,3,2); imagesc(p_bg, [0,1]); title('Background Intensity');
    
    Dc = zeros(sz(1),sz(2), 2);
    Dc(:,:,1) = -log(p_fg ./ (p_bg + eps));
    Dc(:,:,2) = -log(p_bg ./ (p_fg + eps));
    
    % Construct GraphCut handle
    gch = GraphCut('open', Dc, k1 * Sc, k2 * exp(-Vc), k2 * exp(-Hc));
    % Perform GraphCut
    [gch, L] = GraphCut('swap',gch);
    gch = GraphCut('close', gch);
    % Use L to update fg_mask
    fg_mask = (L==0);
    figure(1);
    subplot(1,3,3);imagesc(fg_mask);title('Segmentation Mask');
end

disp('Graph Cut Done!');
% display
sim = zeros(sz);
% set background as blue
sim(:,:,3) = 1.0;
% set foreground as original pixels
mask = zeros(sz);
for i = 1:sz(3)
    mask(:,:,i) = fg_mask;
end
sim = sim.*(1-mask) + im .* mask;
figure(2);
imshow(sim); title('Segmentation Results using Graph Cut');

% save to file
imwrite(sim, './segmentation.png');

%-----------------------------------------------%
function [hC vC] = edge_potential(im)
dg = fspecial('log', [13 13], sqrt(13));
sz = size(im);

vC = zeros(sz(1:2));
hC = vC;

for b=1:size(im,3)
    vC = max(vC, abs(imfilter(im(:,:,b), dg, 'symmetric')));
    hC = max(hC, abs(imfilter(im(:,:,b), dg', 'symmetric')));
end
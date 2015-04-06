% [S time] = segment_box(image, n)
% 
% Perfom box segmentation
%
% Parameters
%   image      ... Matlab image
%   n          ... (approximate) number of superpixels 
%
% Returns
%   S    ... segment image
%   time ... execution time im ms of algorithm 
%
function [S time] = segment_box(image,n)
   
    if ~exist('n','var') | isempty(n),   n = 100;   end
    
    % execute 
    tic();
    
    [h w c] = size(image);    
    B = zeros(h,w);
    
    ny = sqrt( n*h/w);
    nx = n/ny;
        
    dx = w/nx;
    dy = h/ny;
    
    for i=dx:dx:(w-dx)
        B(:, round(i)) = 255;
    end
    
    for i=dy:dy:(h-dy)
        B(round(i), :) = 255;
    end
    time = toc();
    
    % create multi-label-image
    S = uint16(boundaryImage2multiLabelImage(B));
    
end

function mli = boundaryImage2multiLabelImage(bim)
    inv_bim = max(bim(:))-bim;
    label_im = bwlabel(inv_bim,4);
    mli = imclose( label_im, strel([1 1 1; 1 1 1; 1 1 1]));
end

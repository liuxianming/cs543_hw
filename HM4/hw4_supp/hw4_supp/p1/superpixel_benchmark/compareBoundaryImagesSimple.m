% Superpixel Benchmark
% Copyright (C) 2012  Peer Neubert, peer.neubert@etit.tu-chemnitz.de
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% -------------------------------------
%
% [TP FP TN FN] = compareBoundaryImagesSimple(bim1, bim2, k)
%
% computes true positives, false positives, true negatives and false
% negatives from two boundary images. bim2 is regarded as ground truth
%
% bim1 ... boundary image
% bim2 ... groundtruth boundary image
% k ... maximum distance for neighbored pixel
%
% TP ... number of boundary pixel in bim1 in range k of boundary pixel
% in bim2
%
% FP ... number of boundary pixel in bim1 that are not in range k of any
% boundary pixel in bim2
%
% TN ... number of pixel not set in bim1 and not in bim2 OR not set in bim1 and set in
% bim2 but neighbored to another set pixel in bim1 (this boundary pixel is
% catched by another pixel in bim1, thus this pixel is okay to be negative)
%
% FN ... number of pixel that are not set in bim1 but in bim2 and no set 
% neighbor in range k in bim1
%
function [TP FP TN FN] = compareBoundaryImagesSimple(bim1, bim2, k)

    % expand boundaries to their k-neighborhod
    strel_disk = strel('disk',k);
    bim1_k = imdilate(bim1, strel_disk);
    bim2_k = imdilate(bim2, strel_disk);

    % positives masks
    TP_mask = bim2_k & bim1;
    FP_mask = (1-bim2_k) & bim1;
    
    % some temps
    bim2_and_bim1_k = bim2 & bim1_k;
    not_bim1 = 1-bim1;
    
    % negatives masks
    TN_mask = not_bim1 & ( (1-bim2) | bim2_and_bim1_k );
    FN_mask = not_bim1 & bim2 & (1-bim2_and_bim1_k);
     
    % count TP FP TN FN
    TP = sum(sum( TP_mask )); 
    FP = sum(sum( FP_mask ));
    TN = sum(sum( TN_mask ));
    FN = sum(sum( FN_mask ));
end
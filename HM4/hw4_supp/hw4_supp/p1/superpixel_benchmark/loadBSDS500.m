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
% [images gt names] = loadBSDS500(BSDS500_root, mode, 'n', n, 'idx', idx)
%
% Load images and corresponding ground truth from BSDS500 dataset
%
% parameters:
%   BSDS500_root ... BSDS500 root directory path
%   mode ... 'train' or 'val' or 'test'
% 
% varargin:
%   'n' ... number of images to load (first n images)
%   'idx' ... index of single image to load (index can vary on different
%           machines or operating systems)
%   'name' ... name of single image to load (without file extension) e.g. '100007'
% 
% return values:
%   if no 'idx' is given: 
%       returns cell arrays with images and ground truth
%   otherwise
%       returns image, ground truth and name of image with index idx
%
% example usage:
%   [images gt names] = loadBSDS500('./', 'test', 'n', 100);
%      returns cell array with the first 100 images, ground truth data and
%      image names
%
function [images gt names] = loadBSDS500(BSDS500_root, mode, varargin)

    if isempty(BSDS500_root)
        BSDS500_root = '/home/nepe/etit_arbeit/data_sets/bsds500/BSR/BSDS500/data';
    end

    % parse input
    ip = inputParser;
    ip.addOptional('n', []);
    ip.addOptional('idx', []);
    ip.addOptional('name', []);
    ip.parse(varargin{:});

    % image files
    image_files = dir(fullfile(BSDS500_root,'images', mode, '*.jpg'));

    % number of images
    if isempty(ip.Results.n)
        n=length(image_files);
    else
        n=min(ip.Results.n, length(image_files));
    end
    
    % if no special index was given, load n images
    if isempty(ip.Results.idx) & isempty(ip.Results.name)
    
        % prepare storage
        images = cell(n,1);
        gt = cell(n,1);
        names = cell(n,1);

        % load images and ground truth    
        fprintf('load %4d of %4d', 10, n);
        for i=1:n
            if mod(i,10) == 0  
                fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
                fprintf('load %4d of %4d', i, n);
            end
            images{i} = imread( fullfile(BSDS500_root,'images', mode, image_files(i).name) );
            gt{i} = load( fullfile(BSDS500_root,'groundTruth', mode, [image_files(i).name(1:end-4) '.mat']));
            names{i} = image_files(i).name(1:end-4);
        end
        fprintf('\n');
        
    elseif ~isempty(ip.Results.name)
        % load image with name name        
        [images gt names] = loadBSDS500perName(BSDS500_root, mode, ip.Results.name);
        
    elseif ~isempty(ip.Results.idx)
        % just load the image with index idx
        [images gt names] = loadBSDS500perIdx(BSDS500_root, mode, ip.Results.idx);
    end
end

% load image with index index
function [image gt name] = loadBSDS500perIdx(BSDS500_root, mode, idx)
    
    % image files
    image_files = dir(fullfile(BSDS500_root,'images', mode, '*.jpg'));
    
    % load
    image = imread( fullfile(BSDS500_root,'images', mode, image_files(idx).name) );
    gt = load( fullfile(BSDS500_root,'groundTruth', mode, [image_files(idx).name(1:end-4) '.mat']));
    name = image_files(idx).name(1:end-4);
end

% load image with index index
function [image gt name] = loadBSDS500perName(BSDS500_root, mode, name)
    
    % image files
    image_files = dir(fullfile(BSDS500_root,'images', mode, '*.jpg'));
    
    % load
    image = imread( fullfile(BSDS500_root,'images', mode, [name '.jpg']) );
    gt = load( fullfile(BSDS500_root,'groundTruth', mode, [name '.mat']));
    
end
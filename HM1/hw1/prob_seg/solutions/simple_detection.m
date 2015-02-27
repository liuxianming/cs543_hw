img_root = '../../data/images';
save_root = '../../results/simple_edge';

addpath('../../util')
addpath('../')
addpath('../../');

filenames = dir([img_root, '/*.jpg']);

for i = 1:size(filenames,1)
    imgpath = fullfile(img_root, filenames(i).name);
    savepath = fullfile(save_root, filenames(i).name);
    im = im2double(imread(imgpath));
    
    bmap = edgeGradient(im);
    imwrite(bmap, savepath);
end
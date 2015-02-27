% I/O: Read image and turn it to gray, and turn from unit8 to double
img = rgb2gray(imread('./test.jpg'));
img = im2double(img)/255;

[g_pyramid, l_pyramid] = gaussian_pyramids(img, 5);
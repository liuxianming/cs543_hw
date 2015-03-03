% CS543 Homework 2-2: Shape alignment
% 1: object1->object2
disp('Aligning Object1.png to Object2.png...');
im1 = imread('object1.png')>0;
im2 = imread('object2.png')>0;
T12 = align_shape(im1, im2);
% Display and evaluate 
displayAlignment(im1, im2, T12);
=== CS 543/ECE 549 Computer Vision HW 2 (2): Shape Alignment ===

Instructions to evaluate your shape alignment algorithm on a subset of the MPEG-7 shape dataset (http://www.dabi.temple.edu/~shape/MPEG7/dataset.html).

Step 1. Copy your shape alignment code "align_shape.m" to this folder

% aligned: warped image im1 to image im2
T = align_shape( im1, im2);

T is the transformation matrix that map points in im1 to points im2.
For example, for 
T = [1, 0, 10; 
       0, 1,  20; 
       0, 0,   1];
it will translate the points by (10, 20).

Step 2. Run evalAlignmentAll.m
After aligning all 25 image pairs, you will get the averaged alignment error in the Matlab command window.

Step 3. Share your result by submitting it to a public leaderboard
- submit link: http://goo.gl/forms/bjdg6yAv1F
- result link: https://docs.google.com/spreadsheets/d/1vrRZZYpd1Jc_Gim2vnEtYroSgRQqXE5EG0hrdBemgSE/edit?usp=sharing

Note that submitting results is not mandatory and will not affect your grade.

Have fun!
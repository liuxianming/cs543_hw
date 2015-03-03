% CS543 Homework 2-2: Shape alignment
% 1: object1->object2
disp('Aligning Object2.png to Object1.png...');
T21 = align_shape(imread('object2.png')>0, imread('object1.png')>0);
title('Align Ojbect2 to Object1');
% 2: object2->object2t
disp('Aligning Object2.png to Object2t.png...');
T22t = align_shape(imread('object2.png')>0, imread('object2t.png')>0);
title('Align Ojbect2 to Object2t');
% 3: object2->object2t
disp('Aligning Object2.png to Object3.png...');
T23 = align_shape(imread('object2.png')>0, imread('object3.png')>0);
title('Align Ojbect2 to Object3');
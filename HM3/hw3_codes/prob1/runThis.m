%% Problem 1 for Homework 3: Single-View Metrology
%--------------------------------------------------%
% Read image
%--------------------------------------------------%
im = imread('kyoto_street.JPG');
%--------------------------------------------------%
% A.1 Get three orthogonal Vinishing points
%--------------------------------------------------%
disp('Getting Three Orthogonal Vanishing points');

vp = zeros(3,3);

disp('1. Draw and calculate the FIRST VP, in horizontal direction [1, 0, 0].');
vp(:,1) = getVanishingPoint(im);
pause();

disp('2. Draw and calculate the SECOND VP, in horizontal direction [0 ,1 ,0]');
vp(:,2) = getVanishingPoint(im);
pause();

disp('3. Draw and calculate the THIRD VP, in vertical direction [0, 0, 1]');
vp(:,3) = getVanishingPoint(im);
pause();

fprintf(1,'Three VPs are: (%f, %f), (%f, %f), (%f, %f)\n', vp(1,1), vp(2,1), vp(1,2), vp(2,2), vp(1,3), vp(2,3));

%--------------------------------------------------%
% A.2 Ploting the horizon line 
%     and specify its parameters as au+bv+c=0  
%     with normalized a^2+b^2=1
%--------------------------------------------------%
disp('Continue to calculate intrinsic matrix of camera...');
hline = real(cross(vp(:,1), vp(:,2)));
% normalization
hline = hline ./ norm([hline(1), hline(2)]);
fprintf(1,'The horizontal vanishing line is %fu+%fv+%f=0\n',hline(1), hline(2), hline(3));
%plotting to image
figure(1); imshow(im);
x = 1:size(im,2); y = -(hline(1) * x + hline(3)) / hline(2);
plot(x,y,'r', 'linewidth', 3);

%--------------------------------------------------%
%B. Solving camera focal length and optical center (u0, v0)
%   Using matlab solving function solve() here
%--------------------------------------------------%
disp('Solving intrinsic matrix...');
syms f u v;
% Intrinsic matrix [f, 0, u; 0, f, v; 0, 0, 1]
% using vp_i' * (K^-1)' * K^-1 * vp_j = 0
% calculate KK = (K^-1)' * K^-1
KK = [f^-2, 0, -u/f^2; 0, f^-2, -v/f^2; -u/f^2, -v/f^2, (u/f)^2+(v/f)^2+1];
eqn1 = vp(:,1)'* KK * vp(:,2) == 0;
eqn2 = vp(:,1)'* KK * vp(:,3) == 0;
eqn3 = vp(:,2)'* KK * vp(:,3) == 0;
disp('Solving equations...');
solutions = solve(eqn1, eqn2, eqn3, f, u, v);
f = eval(vpa(solutions.f(1))); f = abs(f);
u0 = eval(vpa(solutions.u(1)));
v0 = eval(vpa(solutions.v(1)));
fprintf(1,'Focal Length = %.2f, optical center at (%.2f, %.2f)\n', f, u0, v0);

%--------------------------------------------------%
%C. Solving rotation matrix
%--------------------------------------------------%
R = zeros(3,3);
K = [f, 0, u0; 0, f, v0; 0, 0, 1];
R(:,1) = K \ vp(:,1);
R(:,2) = K \ vp(:,2);
R(:,3) = - K \ vp(:,3);
% Normalization since R*R' = I
R(:,1) = R(:,1) / norm(R(:,1));
R(:,2) = R(:,2) / norm(R(:,2));
R(:,3) = R(:,3) / norm(R(:,3));
disp('Rotation Matrix R = ');
R
disp('Done');
%--------------------------------------------------%
% Finish
%--------------------------------------------------%
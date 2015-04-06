function [ f, u0, v0, R] = camera_calib( vp )
%CAMERA_CALIB Camera Calibration
% Homework 3, problem 1, Extra Credit E(2)
% Input: 
%   vp: vanishing point, in x, y, z direction respectively, in col 1, 2, 3
% Output:
%   K - Intrinsic Matrix, R - Rotation Matrix

%% Start of function
%--------------------------------------------------%
% Solving camera focal length and optical center (u0, v0)
% Using matlab solving function solve() here
%--------------------------------------------------%
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

%--------------------------------------------------%
% Solving rotation matrix
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

end


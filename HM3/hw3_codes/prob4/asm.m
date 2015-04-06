function [K,X,A] = asm(Xs,Ys)
%Affine Structure from Motion
%inputs: Xs and Ys are the tracked positions of keypoints through 51 frames;
%outputs: K is the 3D position of camera through 51 frames;
%         X is the 3D position of all keypoints;
%         A is the Affine Projection Matrix;
tempXs = bsxfun(@minus,Xs,mean(Xs,2));
tempYs = bsxfun(@minus,Ys,mean(Ys,2));

[m,n] = size(Xs);

for i = 1:size(Xs,1)
%     D(2*i-1,:) = tempXs(i,:);
%     D(2*i,:) = tempYs(i,:);
    D(i,:) = tempXs(i,:);
    D(m+i,:) = tempYs(i,:);
end


[U W V] = svd(D);
U3 = U(:,1:3);
V3 = V(:,1:3);
W3 = W(1:3,1:3);

A = U3*sqrt(W3);
X = sqrt(W3)*V3';

for i = 1:m
    p = A(i,:);
    q = A(i+m,:);
    C(3*i-2,:) = [p(1)^2 p(1)*p(2) p(1)*p(3) p(1)*p(2) p(2)^2 p(2)*p(3) p(1)*p(3) p(2)*p(3) p(3)^2];
    C(3*i-1,:) = [q(1)^2 q(1)*q(2) q(1)*q(3) q(1)*q(2) q(2)^2 q(2)*q(3) q(1)*q(3) q(2)*q(3) q(3)^2];
    C(3*i,:) = [p(1)*q(1) p(1)*q(2) p(1)*q(3) q(1)*p(2) p(2)*q(2) p(2)*q(3) q(1)*p(3) q(2)*p(3) q(3)*p(3)];
    b(3*i-2,:) = 1;
    b(3*i-1,:) = 1;
    b(3*i,:) = 0;
end

l = C\b;
L = reshape(l,[3 3])';
c = chol(L,'lower');
A = A*c;
X = c\X;
for i = 1:size(Xs,1)
    K(i,:) = cross(A(i,:),A(m+i,:));
    K(i,:) = K(i,:)/sqrt(sum(K(i,:).^2,2));
end
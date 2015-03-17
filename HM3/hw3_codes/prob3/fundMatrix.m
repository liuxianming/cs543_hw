function [F] = fundMatrix(idx,c1,r1,c2,r2)
% Using SVD to solve

x1 = c1(idx(:,1));
y1 = r1(idx(:,1));
x2 = c2(idx(:,2));
y2 = r2(idx(:,2));

a = [(x1-mean(x1)) (y1-mean(y1))];
b = [(x2-mean(x2)) (y2-mean(y2))];
s1 = 1/(std(sqrt(sum(a.^2,2))))*sqrt(2);
s2 = 1/(std(sqrt(sum(b.^2,2))))*sqrt(2);
a = a*s1;
xx1 = a(:,1);
yy1 = a(:,2);
b = b*s2;
xx2 = b(:,1);
yy2 = b(:,2);
T1 = [s1 0 0;0 s1 0;0 0 1]*[1 0 -mean(x1);0 1 -mean(y1);0 0 1];
T2 = [s2 0 0;0 s2 0;0 0 1]*[1 0 -mean(x2);0 1 -mean(y2);0 0 1];

A = zeros(size(idx,1),9);
for i = 1:size(idx,1)
    A(i,:) = [xx2(i)*xx1(i) xx2(i)*yy1(i) xx2(i) yy2(i)*xx1(i) yy2(i)*yy1(i) yy2(i) xx1(i) yy1(i) 1];
end

[U,S,V] = svd(A);
f = V(:,end);
F = reshape(f,[3 3])';
[U1,S1,V1] = svd(F);
S1(3,3) = 0;
F = U1*S1*V1';
F = T2'*F*T1;
F = F*(sqrt(1/sum(sum(F.^2))));

end
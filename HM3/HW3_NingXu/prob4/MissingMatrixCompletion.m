function [X1 Y1] = MissingMatrixCompletion(X,Y)

Xs = X(1:3,X(3,:)>0);
Ys = Y(1:3,X(3,:)>0);

[K,S,A] = ASM(Xs,Ys);
%%
X1 = X(:,X(3,:)>0);
Y1 = Y(:,X(3,:)>0);
newA = zeros(102,3);
newA(1:3,:)=A(1:3,:);
newA(52:54,:)=A(4:6,:);
for i = 4:51
    flag = X1(i,:)>0;
    newS = bsxfun(@minus,S(:,flag),mean(S(:,flag),2));
    temp = [X1(i,flag);Y1(i,flag)];
    W = [X1(i,:);Y1(i,:)];
    newW = bsxfun(@minus,temp,mean(temp,2));
    a = newW*pinv(newS);
    newA(i,:) = a(1,:);
    newA(51+i,:) = a(2,:);
    e = zeros(size(X1,2),1);
    e(flag) = 1;
    t = 1/sum(e)*(W-a*S)*e;
    u = ones(1,size(X1,2));
    tempW = a*S + t*u;
    X1(i,:) = tempW(1,:);  
    Y1(i,:) = tempW(2,:);
end


% figure, imshow(im), axis([-100,1000,-100,1000]), hold on;
% for i = 1:size(X,2)
%         plot(X(:,i), Y(:,i),'r-', 'linewidth',3), hold on;
%  end

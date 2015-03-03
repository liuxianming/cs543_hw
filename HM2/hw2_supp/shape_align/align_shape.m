function T = align_shape( im1, im2 )
%ALINE_SHAPE Align two shape (im1, and im2, binary) by estimating a
%transform
% Using affaine transform to estimate T, and ICP algorithm

% Start timer
tic;

% Parameters
iteration = 10;
% Allocating space for errors
ER = zeros(iteration,2); 

% Intialization
[row1, col1] = find(im1);
[row2, col2] = find(im2);
mean1 = [mean(row1), mean(col1)];
mean2 = [mean(row2), mean(col2)];
% Initialize translation 
x_translation = mean2(1) - mean1(1);
y_translation = mean2(2) - mean1(2);

% Estimate rotation using pca - that is eigenvalues of covariance matrix
dir1=pca([row1+x_translation,col1+y_translation]);
dir2=pca([row2,col2]);
rot=dir2/dir1;

% Estimate the scaling: 
% calculating average distance to center and compute the ratio
%scale1=sqrt(sum((row1-mean1(1)).^2+(col1-mean1(2)).^2)/length(row1));
%scale2=sqrt(sum((row2-mean2(1)).^2+(col2-mean2(2)).^2)/length(row2));
%scale=scale2/scale1;
scale = 1;

% Iteratively perform ICP
shape2 = [row2 col2];
shape1 = [row1 col1 ones(size(row1))];

% Intialize a transformation matrix T
T = [scale * rot, [x_translation; y_translation]];

for iter = 1:iteration
    % 1. Apply transformation
    shape12 = (T * shape1')';
    % reconstruct translated image
    t_im1 = zeros(size(im2));
    for i = 1:size(shape12, 1)
        tx = floor(shape12(i, 1)); ty = floor(shape12(i,2));
        if tx>0 && tx<=size(im2,1) && ty>0 && ty<=size(im2,2)
            t_im1(tx,ty) = 1;
        end
    end
    ER(iter, 1) = evalAlignment(t_im1, im2);
    figure(1); imshow(t_im1); pause()
    % 2. Search for cloest point (using euclidean distance)
    %using built-in function knnsearch
    [nnidx, mindist] = knnsearch(shape2, shape12, 'k', 1, 'NSMethod', 'kdtree');    
    % 3. Calculate the error
    ER(iter,2) = sum(mindist);
    target = shape2(nnidx, :); % target is the cloest matched points
    % 4. Solve the new T using least square solution
    % Solve the equation Ax=b, and x = A\b
    A = zeros(size(shape1) * 2);
    for i = 1:size(shape1, 1)
        A(2*i-1,1:3) = shape1(i,:);
        A(2*i, 4:6) = shape1(i,:);
    end
    target = target';
    b = target(:);
    T = A\b;
    T = reshape(T, [3,2])';
end

figure(); imshow(im2); hold on; 
plot(shape12(2,:), shape12(1,:), 'r+');
t = toc;
disp(t);
% show errors
figure();
plot(1:iter, ER(:,1)); grid on; title('Error of matching in the loop');
end


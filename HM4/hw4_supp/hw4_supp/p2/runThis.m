%% CS 543 Computer Vision Homework 4 - Problem 2: EM algorithm
% University of Illinois, ECE Department, Xianming Liu

% load data
load('annotation_data.mat');

ITER = 20;
N_ANNOTATOR = 25;
N_IMG = 150;
N_ANNOTATION = length(annotation_scores);
N_ANNOTATION_PER_IMG = 5;
N_ANNOTATION_PER_USER = N_ANNOTATION / N_ANNOTATOR;

M = ones(1,N_ANNOTATOR); % initialize all annotators be "good"
beta = 0.5 * ones(1,N_ANNOTATOR); % initalize beta as a random probability
img_scores = zeros(1, N_IMG); % initialize image scores

sigma = 1;
mu = 0.5 * ones(1, N_IMG);

a = zeros(N_IMG, N_ANNOTATOR);

for iter = 1:ITER
    % E-step
    for idx = 1:N_ANNOTATION
        i = image_ids(idx);
        j = annotator_ids(idx);
        
        a(i,j) = normpdf(annotation_scores(idx), mu(i), sigma) * beta(j) ...
            / ((1-beta(j))/10+normpdf(annotation_scores(idx), mu(i), sigma) * beta(j));
    end
    
    % Show user goodness
    s = logsumexp(a, 1);
    figure(1); 
    bar(1:N_ANNOTATOR, s); grid on; drawnow; 
    %pause();
    
    % M-Step
    % estimate mu
    for i = 1:N_IMG
        scores_i = annotation_scores(image_ids==i);
        annotators = annotator_ids(image_ids==i);
        aa = a(i,annotators);
        
        mu(i) = sum(scores_i' .* aa) / sum(aa);
    end
    % estimate sigma
    s = 0;
    for idx = 1:N_ANNOTATION
        i = image_ids(idx);
        j = annotator_ids(idx);
        s = s + a(i,j) * (annotation_scores(idx) - mu(i))^2;
    end
    sigma = sqrt(s /sum(sum(a))); 
    % estimate beta
    beta = sum(a,1) / N_ANNOTATION_PER_USER;
end

% plot the mean scores for each image
figure(2);
bar(1:N_IMG, mu); grid on; title('Mean scores for each image');
figure(3);
bar(1:N_ANNOTATOR, beta); grid on; title('Good or Bad');
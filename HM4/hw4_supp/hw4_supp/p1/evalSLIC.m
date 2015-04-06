% Evaluate SLIC implementation

% 
% CS 543 / ECE 549 Computer Vision, Spring 2015
% University of Illinois, Urbana-Champaign

addpath(genpath('BSR'));
addpath(genpath('superpixel_benchmark'));

% Run the complet benchmark
main_benchmark('evalSlicSetting.txt');

% Report the case with K = 256
load('result\slic\slic_256\benchmarkResult.mat');

avgRecall   =  mean(imRecall(:));
avgUnderseg =  mean(imUnderseg(:));
fprintf('Average boundary recall = %f for K = 256 \n' , avgRecall);
fprintf('Average underseg error  = %f for K = 256 \n' , avgUnderseg);

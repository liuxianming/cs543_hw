% Evaluate SLIC implementation

% 
% CS 543 / ECE 549 Computer Vision, Spring 2015
% University of Illinois, Urbana-Champaign

addpath(genpath('BSR'));
addpath(genpath('superpixel_benchmark'));

% Run the complet benchmark
main_benchmark('evalSlicSetting.txt');

avgRecall = zeros(1,7);
avgUnderseg = zeros(1,7);
runtime = zeros(1,7);

k = [25 36 49 100 256 1600 2500];
for i = 1:7
    benchmarkRsltName = sprintf('result/slic/slic_%d/benchmarkResult.mat', k(i));
    runTimeName = sprintf('result/slic/slic_%d/runtimes.mat', k(i));
    load(benchmarkRsltName);
    load(runTimeName);
    avgRecall(i)   =  mean(imRecall(:));
    avgUnderseg(i) =  mean(imUnderseg(:));
    runtime(i) = mean(imRuntime(:));
end

figure(1); hold on; plot(k, avgRecall, '+-');
figure(2); hold on; plot(k, avgUnderseg, '+-');
figure(3); hold on; plot(k, runtime, '+-');
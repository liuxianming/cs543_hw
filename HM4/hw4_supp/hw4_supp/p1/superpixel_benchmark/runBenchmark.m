% Superpixel Benchmark
% Copyright (C) 2012  Peer Neubert, peer.neubert@etit.tu-chemnitz.de
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% -------------------------------------
%
% runBenchmark(filename)
%
% Load benchmark parameter file and run its benchmark setting(s).
% This function loads the results of a prior run of runAlgorithm and
% computes the error metrics. Results are stored to disk at the location
% specified in the bpf-file
%
% filename ... input benchmark parameter filename (bpf-file)
%
function runBenchmark(filename)

    %% load benchmark parameter file
    p = parseBenchmarkParameterFile(filename);
    
    %% load benchmark images
    [images gt names] = loadBSDS500(p.BSDS500_root, p.mode, p.nImages);
    
    % for each parameterset 
    for parameterset_idx=1:length(p.parameterset)
        n = length(images);
        
        % prepare storage
        imName = zeros(n,1);
        imNSegments = zeros(n,1);
        imRecall = zeros(n,1);
        imPrecision = zeros(n,1);
        
        fprintf('working on parameter set: %s, image:%4d', p.parameterset{parameterset_idx}.name, 0);
        % for each image
        for i=1:n
            fprintf('\b\b\b\b%4d',i);
            % load algorithm result
            loadPath = fullfile(p.algResSavePath, p.parameterset{parameterset_idx}.name, [(names{i}) '.png']);            
            S = imread(loadPath);
            
            % create boundary image from segment image
            B = multiLabelImage2boundaryImage(S);
            
            % Benchmark
            
            % TP FP TN FN
            combinedGTBim = combineMultipleBoundaryImages(gt{i}.groundTruth);
            [imTP imFP imTN imFN] = compareBoundaryImagesSimple(B, combinedGTBim, 2);
            recall = imTP/(imTP+imFN);
            precision = imTP/(imTP+imFP);
            
            % number of segments
            nSegments = max(S(:));
            
            % undersegmentation error
            sumUndersegError = 0;
            sumUndersegErrorTP = 0;
            sumUndersegErrorSLIC = 0;
            for j=1:length(gt{i}.groundTruth)
                [undersegError, undersegErrorTP, undersegErrorSLIC] = getUndersegmentationError(S, gt{i}.groundTruth{j}.Segmentation);
                sumUndersegError = sumUndersegError + undersegError;
                sumUndersegErrorTP = sumUndersegErrorTP + undersegErrorTP;
                sumUndersegErrorSLIC = sumUndersegErrorSLIC + undersegErrorSLIC;     
            end
            undersegError = sumUndersegError/length(gt{i}.groundTruth);
            undersegErrorTP = sumUndersegErrorTP/length(gt{i}.groundTruth);
            undersegErrorSLIC = sumUndersegErrorSLIC/length(gt{i}.groundTruth);
            
            
            % store result for this image
            imName(i) = str2double(names{i});
            imNSegments(i) = nSegments;
            imRecall(i) = recall;
            imPrecision(i) = precision;
            imUnderseg(i) = undersegError;
            imUndersegTP(i) = undersegErrorTP;
            imUndersegSLIC(i) = undersegErrorSLIC;
        end
        fprintf('\n');
        
        % load runtimes
        loadPath =  fullfile(p.algResSavePath, p.parameterset{parameterset_idx}.name, 'runtimes.mat');   
        if exist(loadPath)
            runtimes = load(loadPath);
            imRuntime = runtimes.alg_times;

            % store to disk
            savePath =  fullfile(p.algResSavePath, p.parameterset{parameterset_idx}.name, 'benchmarkResult.mat'); 
            save(savePath, 'imName', 'imNSegments', 'imRecall', 'imPrecision', 'imUnderseg', 'imUndersegTP', 'imUndersegSLIC', 'imRuntime');
        else            
            % store to disk
            savePath =  fullfile(p.algResSavePath, p.parameterset{parameterset_idx}.name, 'benchmarkResult.mat'); 
            save(savePath, 'imName', 'imNSegments', 'imRecall', 'imPrecision', 'imUnderseg', 'imUndersegTP', 'imUndersegSLIC');
        end
            
    end
    
end
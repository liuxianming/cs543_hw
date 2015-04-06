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
% runAlgorithmAffine(filenameBPF, filenameAPF)
%
% Load benchmark parameter file and affine parameter file
% and segment images using their benchmark setting. Results are
% stored to disk
% 
% filenameBPF ... input benchmark parameter filename (bpf-file)
% filenameAPF ... input affine parameter filename (apf-file)
%
function runAlgorithmAffine(filenameBPF, filenameAPF)

    %% load benchmark parameter files BPF, APF
    p = parseBenchmarkParameterFile(filenameBPF);
    a = parseAffineParameterFile(filenameAPF);
    
    
    %% load benchmark images (images and their names)
    [images, ~, names] = loadBSDS500(p.BSDS500_root, p.mode, p.nImages);
    
    %% draw border of zeros arround each image to compensate for effects
    %% caused by borders of zeros introduced by affine transformations
    bSize=10;
    for i=1:length(images)       
       images{i} =  [zeros(size(images{i},1),bSize,size(images{i},3)), images{i}, zeros(size(images{i},1),bSize,size(images{i},3))]; % cols
       images{i} =  [zeros(bSize, size(images{i},2),size(images{i},3)); images{i}; zeros(bSize, size(images{i},2),size(images{i},3))]; % rows
    end
    
    %% process each parameterset (run algorithm and process runtime computation)
    for parameterset_idx=1:length(p.parameterset)
        % ===== run algorithm ===
        % replace parameters in algorithmCommand string with values from p.parameterset{idx} 
        % - simple string replace with check if the parameter name is unique in the command string)
        algorithmCommand = p.algorithmCommand;
        for k=1:length(p.parameterset{parameterset_idx}.params)
           
           paramName = p.parameterset{parameterset_idx}.params(k).name;
           paramValue = p.parameterset{parameterset_idx}.params(k).value;
           
           idx = strfind(algorithmCommand, paramName);           
           if length(idx)~=1
               fprintf('Problem in runAlgorithm(): parameter %s was found %d times\n', paramName, length(idx));
               fprintf('(algorithmCommand is: %s)\n', algorithmCommand);
               return;
           end
           algorithmCommand = [algorithmCommand(1:idx-1) paramValue algorithmCommand(idx+length(paramName):end)];           
        end
        fprintf('executing: %s\n', algorithmCommand);
        
        
        % create base storage to save results
        savePathBase =  fullfile(p.algResSavePath, p.parameterset{parameterset_idx}.name, a.algResSavePathExtension); 
        mkdir(savePathBase);
        
        % create storage for original images
        savePathOriginal = fullfile(savePathBase, 'original');
        mkdir(savePathOriginal);
                
        % create storage for transformed images
        for affineSet_idx=1:length(a.affineSet)            
            savePathAffine = fullfile(savePathBase, a.affineSet{affineSet_idx}.name);
            mkdir(savePathAffine);
        end
                
        % - run on image
        % - transform image
        % - run on transformed image
        % - retransform result
        % (- compare) 
        % - save
                
        % for each image
        for i=1:length(images)
            fprintf('working on: %d (name: %s)\n', i, names{i});
            I = images{i};
            
            % save temporarly for algorithms that do not use "I" but load from file
            I_path = fullfile(savePathOriginal, 'temp.png');
            imwrite(I, I_path);
            
            % execute command: 
            %   - input is "I" (color, [0, 255])
            %   - segmentation result is in "S" (integer)
            %   - runtime is stored in"time"
            eval(algorithmCommand);
            
            % save resulting segment image
            savePath = fullfile(savePathOriginal, [(names{i}) '.png']);            
            imwrite(S, savePath, 'bitdepth', 16);
                        
            % run on transformed images
            for j=1:length(a.affineSet)
                % get current transformation and apply on image
                A = a.affineSet{j}.a;
                I = appplyTransform(images{i}, A);                
                
                % save temporarly for algorithms that do not use "I" but load from file
                I_path = fullfile(savePathOriginal, 'temp.png');
                imwrite(I, I_path);
                
                % execute command: 
                %   - input is "I" (color, [0, 255])
                %   - segmentation result is in "S" (integer)
                eval(algorithmCommand);
            
                % retransform
                S_retransformed = appplyTransform(S, inv(A));
                
                % crop
                [h1 w1 c1] = size(images{i});
                [h2 w2 c2] = size(S_retransformed);
                x1 = round( 1-w1/2+w2/2 );
                y1 = round( 1-h1/2+h2/2 );
                x2 = round( w1-w1/2+w2/2 );
                y2 = round( h1-h1/2+h2/2 );
                               
                S_cropped = S_retransformed( y1:y2, x1:x2 );
                
                % save
                savePath = fullfile(savePathBase, a.affineSet{j}.name, [(names{i}) '.png']);            
                imwrite(S_cropped, savePath, 'bitdepth', 16);
                
            end
            
        end

    end
    
end


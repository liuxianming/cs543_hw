% runAlgorithm(filename)
%
% Load benchmark parameter file and run its algorithm and parameter
% setting. Results are stored to disk at the location specified in the 
% bpf-file.
%
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

%
function runAlgorithm(filename)

    %% load benchmark parameter file
    p = parseBenchmarkParameterFile(filename);
    
    %% load benchmark images (images and their names)
    [images, ~, names] = loadBSDS500(p.BSDS500_root, p.mode, p.nImages);
    
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
    
        % create storage to save results
        savePathBase =  fullfile(p.algResSavePath, p.parameterset{parameterset_idx}.name); 
        mkdir(savePathBase);               
        
        fprintf('executing: %s\n', algorithmCommand);
        % for each image
        for i=1:length(images)
            fprintf('working on: %d (name: %s)\n', i, names{i});
            I = images{i};
            I_path = fullfile(p.BSDS500_root,'images', p.mode, [names{i} '.jpg']);           
            
            % execute command: 
            %   - input is "I" (color, [0, 255])
            %   - segmentation result is in "S" (integer)
            %   - runtime is stored in "time"
            eval(algorithmCommand);
            
            % save resulting segment image
            savePath = fullfile(savePathBase, [(names{i}) '.png']);            
            imwrite(S, savePath, 'bitdepth', 16);
            
            % save resulting visualization image
            saveVisPath = fullfile(savePathBase, [(names{i}) '_vis.png']);  
            imwrite(imgVis, saveVisPath);

            % save times
            savePathTimes = fullfile(savePathBase, [(names{i}) '_time']); 
            save(savePathTimes, 'time');
        end
        
        % ===== load all times, build runtimes matrix and store in runtimes.mat ====
        % storage for algorithm run times alg_times(i) is time for image i 
        alg_times = zeros(length(images),1); 
        for i=1:length(images)
            % load time of image i
            savePathTimes = fullfile(savePathBase, [(names{i}) '_time']); 
            load_time = load(savePathTimes);
            
            % append to alg_times
            alg_times(i) = load_time.time;
        end
        
        % save times
        savePathTimes = fullfile(savePathBase, 'runtimes');    
        save(savePathTimes, 'alg_times');
    end

    
    
end
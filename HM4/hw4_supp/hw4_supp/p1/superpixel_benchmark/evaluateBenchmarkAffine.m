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
% evaluateBenchmarkAffine(filenameBPF, filenameAPF, colors, lineStyles)
%
% Load benchmark parameter file and affine parameter file
% and shows results of their benchmark setting.This function uses the
% results of prior runs of runAlgorithmAffine and runBenchmarkAffine.
% 
% filenameBPF ... input benchmark parameter filename (bpf-file)
% filenameAPF ... input affine parameter filename (apf-file)
% colors ... colors of the plots
% lineStyles ... line styles of the plots
% 
function evaluateBenchmarkAffine(filenameBPF, filenameAPF, colors, lineStyles)

    if ~iscell(filenameBPF)
        filenameBPF = {filenameBPF};
        n=1;
    else
        n = numel(filenameBPF);
    end

   
    if ~exist('colors', 'var')
        for i=1:n
            colors(i,:) = [1; 0; 0];
        end
    end
    
    if ~exist('lineStyles', 'var')
        for i=1:n
            lineStyles{i} = '-';
        end
    end
    
    % for each BPF
    for idx = 1:n
        if isempty(filenameBPF{idx})
            continue;
        end
        
        % load benchmark parameter files BPF, APF
        p = parseBenchmarkParameterFile(filenameBPF{idx});
        a = parseAffineParameterFile(filenameAPF);

        % for each parameterset 
        for parameterset_idx=1:length(p.parameterset)

            % load results for affine set (get precision and recall vectors)
            loadPathBase = fullfile(p.algResSavePath, p.parameterset{parameterset_idx}.name, a.algResSavePathExtension);
            loadPath = fullfile(loadPathBase, 'benchmarkAffineResults.mat');
            if ~exist(loadPath, 'file')
                continue;
            end
            R = load(loadPath, 'R');  

            % compute average F for each affine set
            for i=1:numel(R.R)
                F_vec = 2*R.R{i}.precision.*R.R{i}.recall ./ (R.R{i}.precision + R.R{i}.recall);
                F(i) = mean(F_vec);            
            end

            % rotation
            if strcmp(filenameAPF, 'apf/apf_rotation.txt')
                if exist('f_r', 'var'), f_r = figure(f_r); else f_r = figure(); end
                hold on;
                set(gca,'FontSize',14)
                grid on;
                plot([0 5 10 15 30 45 60 75 90 105 120 135 150 165 180] , [1 F], 'color', colors(idx, :), 'lineStyle', lineStyles{idx}, 'marker', '+');
                xlabel('Rotation angle in degree');
                ylabel('F');
            end

            % translation
            if strcmp(filenameAPF, 'apf/apf_translation.txt')
                if exist('f_t', 'var'), f_t = figure(f_t); else f_t = figure(); end
                hold on;
                set(gca,'FontSize',14)
                grid on;
                plot([1 5 10 20 25 30 40 50 60 70 80 90 100] , F,  'color', colors(idx, :), 'lineStyle', lineStyles{idx}, 'marker', '+');
                xlabel('Horizontal and Vertical Shift in Pixel');
                ylabel('F');
            end

            % sacle
            if strcmp(filenameAPF, 'apf/apf_scale.txt')
                if exist('f_s', 'var'), f_s = figure(f_s); else f_s = figure(); end
                F = [F(1:3), 1, F(4:6)];
                semilogx([0.25 0.5 0.6666 1 1.5 2 4] , F,  'color', colors(idx, :), 'lineStyle', lineStyles{idx}, 'marker', '+');
                hold on;
                set(gca,'FontSize',14)
                set(gca,'XTick',[0.25 0.5 0.6666 1 1.5 2 4])
                set(gca,'XTickLabel',{'0.25', '0.5', '0.66', '1', '1.5',  '2',  '4'})
                xlabel('Scale Factor');
                ylabel('F');
                grid on;
            end

            % shear
            if strcmp(filenameAPF, 'apf/apf_shear.txt')
                if exist('f_ss', 'var'), f_ss = figure(f_ss); else f_ss = figure(); end
                plot([0 0.01 0.025 0.05 0.1 0.25 0.5] , [1 F],  'color', colors(idx, :), 'lineStyle', lineStyles{idx}, 'marker', '+');
                hold on;
                set(gca,'FontSize',14)
                xlabel('Horizontal and Vertical Shear Factor');
                ylabel('F');
                grid on;
            end
        end
    end
    
    
    
end
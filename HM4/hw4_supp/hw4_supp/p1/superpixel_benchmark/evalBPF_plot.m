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
% [fig_handle plot_handle] = evalBPF_plot(filename, varargin)
% 
% Plot benchmark results (boundary recall, undersegmentation error or
% runtime) of a BPF. Called after runAlgorithm and runBenchmark. See
% evaluateBenchmark.m for example usage.
%
% filename ... input benchmark parameter filename (bpf-file)
% 'lineStyle' ... line style of the curve
% 'color' ... color of the plots
% 'figure' ... handle of the figure to draw on (otherwise a new figure is
%              created)
% 'metric' ... 'boundary_recall'
%              'undersegmentation'
%              'runtime'
% 'nameFlag' ... if true, the names from the BPF file are shown 
%
function [fig_handle plot_handle] = evalBPF_plot(filename, varargin)

    
    % parse input
    ip = inputParser;
    ip.addOptional('figure', []);
    ip.addOptional('color', 'k');
    ip.addOptional('lineStyle', '-');
    ip.addOptional('metric', 'boundary_recall');
    ip.addOptional('nameFlag', 0);
    ip.parse(varargin{:});
   
    % prepare figure or use existing figure given by parameter
    if isempty(ip.Results.figure)
        fig_handle = figure();
        hold on;
        grid on;
    else
        fig_handle = figure(ip.Results.figure);
    end
    
    % parse benchmark parameter file
    p = parseBenchmarkParameterFile(filename);
    
    % build parameterSetNames by using all parameter set names from
    % benchmark parameter file 
    parameterSetNames = cell(length(p.parameterset),1);
    for parameterset_idx=1:length(p.parameterset)
        parameterSetNames{parameterset_idx} = p.parameterset{parameterset_idx}.name;
    end
    
    % for each entry in parameterSetNames: load results from disk and
    % collect data
    E = [];
    for i=1:length(parameterSetNames)
        % load from disk
        loadPath =  fullfile(p.algResSavePath, parameterSetNames{i}, 'benchmarkResult.mat'); 
        benchmarkResult = load(loadPath);
        
        % number of segments
        E(i).x = mean(benchmarkResult.imNSegments);
        
        if strcmp(ip.Results.metric, 'boundary_recall')
            % store average recall for later plotting of curve          
            E(i).y = mean(benchmarkResult.imRecall); 
        elseif strcmp(ip.Results.metric, 'undersegmentation')
            % store average undersegmentation error for later plotting of curve
            E(i).y = mean(benchmarkResult.imUnderseg); 
        elseif  strcmp(ip.Results.metric, 'runtime')
            % store average runtime and nSegments for later plotting of curve
            E(i).y = mean(benchmarkResult.imRuntime); 
        end
    end
    
    % plot curve
    yVec = cell2mat({E(:).y});
    xVec = cell2mat({E(:).x});
    plot_handle = plot(xVec, yVec, 'color', ip.Results.color, 'marker', 'o'); 
    plot_handle = plot(xVec, yVec, 'color', ip.Results.color, 'LineStyle', ip.Results.lineStyle);
    
    % show names
    if ip.Results.nameFlag
        if ~isempty(ip.Results.namesColor)
            for i=1:length(E)
                text(E(i).x,E(i).y,['  ' parameterSetNames{i}],...
                    'Clipping', 'on', ...
                    'Interpreter', 'non', ...
                    'color', ip.Results.namesColor);
            end
        else
             for i=1:length(E)
                text(E(i).x,E(i).y,['  ' parameterSetNames{i}],...
                    'Clipping', 'on', ...
                    'Interpreter', 'non', ...
                    'color', colors(i,:));
             end
        end
    end
    
end
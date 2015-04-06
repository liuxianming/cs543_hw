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
% evaluateBenchmark(filename, varargin)
%
% Creates and shows evaluation of the results of a prior run of
% runBenchmark. Evaluation includes boundary recall, undersegmentation
% erros and runtime.Most parameters (e.g. path of the stored benchmark 
% results) come from a bpf-file.
%
% 'PR_scheme' ... 'line', 'points', 'contours', 'areas'
% 'names' ... names for the legend (cell array of string included in the plots (e.g. names of the
%             algorithms))
%
function evaluateBenchmark(filename, varargin)

     % parse input
    ip = inputParser;
    ip.addOptional('PR_scheme', 'line');
    ip.addOptional('names', 'result');
    ip.parse(varargin{:});
   
    % recall-#Segments
    nrFig = figure(); 
    prepareBoundaryRecallPlot();
   
    % undersegmentation error-#Segments
    nuFig = figure(); 
    prepareUndersegmentationErrorPlot();
    
    % time
    tFig = figure();
    prepareRuntimePlot(1);
    
    
    % show files
    if iscell(filename)
        % prepare plot handles
        nrHandles = zeros(length(filename), 1);
        nuHandles = zeros(length(filename), 1);
        tHandles = zeros(length(filename), 1);   
        
        [colors ls] = getHighContrastColormap;
        for i=1:length(filename)
            [~, nrHandles(i)] = evalBPF_plot(filename{i},'figure', nrFig, 'metric', 'boundary_recall', 'color', colors(i,:), 'lineStyle', ls{i}, 'nameFlag', 0);
            [~, nuHandles(i)] = evalBPF_plot(filename{i},'figure', nuFig, 'metric', 'undersegmentation', 'color', colors(i,:), 'lineStyle', ls{i}, 'nameFlag', 0);
            [~, tHandles(i)] = evalBPF_plot(filename{i},'figure', tFig, 'metric', 'runtime', 'color', colors(i,:), 'lineStyle', ls{i}, 'nameFlag', 0);
        end
        
        % legend
        figure(nrFig); legend( nrHandles, ip.Results.names, 'Location','SouthEast');
        figure(nuFig); legend( nuHandles, ip.Results.names);
        figure(tFig); legend( tHandles, ip.Results.names);
        
    else
        % just plot
        evalBPF_plot(filename,'figure', nrFig, 'metric', 'boundary_recall','nameFlag', 0);
        evalBPF_plot(filename,'figure', nuFig, 'metric', 'undersegmentation', 'nameFlag', 0);
        evalBPF_plot(filename,'figure', tFig, 'metric', 'runtime', 'nameFlag', 0);
        
    end
end



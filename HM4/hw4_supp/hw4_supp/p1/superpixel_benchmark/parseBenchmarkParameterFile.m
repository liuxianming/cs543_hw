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
% p = parseBenchmarkParameterFile(filename)
% 
% parse file with parameters for benchmark
% available benchmark parameters
% 	BSDSroot
% 	mode
% 	parameterset
% 	saveImPath
% 	saveBenchResPath
%   algorithmCommand (->executed using "eval")
%
function p = parseBenchmarkParameterFile(filename)
    infile = fopen(filename,'rt');
    p.parameterset = {};
    
    while not(feof(infile))
        line = fgetl(infile);
        data = strread(line,'%s');
        if ~isempty(data)
            
            if strcmp(data(1), 'BSDS500_root')
                p.BSDS500_root = data{2};
            elseif strcmp(data(1), 'mode')
                p.mode = data{2};
            elseif strcmp(data(1), 'algResSavePath')
                p.algResSavePath = data{2};
            elseif strcmp(data(1), 'benchResSavePath')
                p.benchResSavePath = data{2};
            elseif strcmp(data(1), 'nImages')
                p.nImages = str2double(data{2});
            elseif strcmp(data(1), 'algorithmCommand')                
                % the algorithm command is the rest of the line
                p.algorithmCommand = line(length('algorithmCommand')+2:end);
            elseif strcmp(data(1), 'parameterset')
                
                % add a (further) set of parameters, the parameters 
                % are assumed to appear pairwise: 
                %    parameterset name1 value1 name2 value2 ...
                t=[];
                idx=1;
                for i=2:2:(length(data)-1) 
                    % update saveName
                    if strcmp(data{i}, 'parametersetName')
                        parametersetName = data{i+1};
                        continue;
                    end
                    
                    % otherwise store
                    t(idx).name = data{i};
                    t(idx).value = data{i+1};
                    
                    idx = idx+1;
                end               
                newIdx = length(p.parameterset)+1;
                p.parameterset{newIdx}.params = t;
                p.parameterset{newIdx}.name = parametersetName;
            end 
            
        end
        
    end
    fclose(infile);
end
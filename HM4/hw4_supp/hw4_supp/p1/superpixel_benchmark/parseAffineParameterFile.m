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
% p = parseAffineParameterFile(filename)
% 
% parse file with parameters for affine transformations
%
% The transformation conventions follow
%   http://www.mathworks.de/help/toolbox/images/f12-26140.html#f12-31782
% 
%   y=x*A
%
%   e.g. translation: A=[ 1  0  0 ;
%                         0  1  0 ;
%                         dx dy 1 ];
%
% available benchmark parameters
% 	algResSavePathExtension ... extension to saveBenchResPath of used BPF
% 	affine_trafo
%       affine_trafo name a11 a12 a13 a21 a22 a23 a31 a32 a33
function p = parseAffineParameterFile(filename)
    infile = fopen(filename,'rt');
    p.affineSet = {};
    
    while not(feof(infile))
        line = fgetl(infile);
        data = strread(line,'%s');
        if ~isempty(data)
            
            if strcmp(data(1), 'algResSavePathExtension')
                p.algResSavePathExtension = data{2};
            elseif strcmp(data(1), 'affine_trafo')                
                % add a (further) affine transformation, the trafo
                % is assumed to come in row first order:
                %    affine_trafo name a11 a12 a13 a21 a22 a23 a31 a32 a33
                newIdx = length(p.affineSet)+1;
                p.affineSet{newIdx}.a = [str2num(data{3}) str2num(data{4}) str2num(data{5}); str2num(data{6}) str2num(data{7}) str2num(data{8}); str2num(data{9}) str2num(data{10}) str2num(data{11})];
                p.affineSet{newIdx}.name = data{2};
            end 
            
        end
        
    end
    fclose(infile);
end
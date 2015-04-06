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
% [C L] = getHighContrastColormap
%
% Get set of colors and line styles with high contrast
%
% C ... colormap
% L ... cell array with strings of the linestyles
%
function [C L] = getHighContrastColormap

     values = [ 
                0.2 0.2 1;
                1 0 0;
                0.2 1 0.2;
                0.5 0 0.5;
                0.8 0.8 0;
                0 1 1;
                1 0 1;
                0.6 0.6 0.6;
                0 0 0;
                0 0.5 0;
                1 0.5 0];
            
     C = colormap(values);

     L = {'-', '-.', '--', '-', '-.', '--', '-', '-.', '--','-.', '-', '--', '-'};
end

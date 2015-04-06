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
% prepareBoundaryRecallPlot
% 
% Setup figure properties for plot
%
function prepareBoundaryRecallPlot
    hold on;
    set(gca,'FontSize',14);    
    axis( [0 2500 0 1] );
    xlabel('Number of Segments');
    ylabel('Boundary Recall');
    ylim([0 1]);
    grid on;
end
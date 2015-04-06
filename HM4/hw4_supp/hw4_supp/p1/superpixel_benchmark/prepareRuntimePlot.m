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
% prepareRuntimePlot(log_flag)
% 
% Setup figure properties for plot
%
% log_flag ... logarithmic scale?
%
function prepareRuntimePlot(log_flag)

    % logarithmic scale?
    if exist('log_flag', 'var')>0 && log_flag==1
        semilogy(0,0);
        set(gca,'YTick',[0.1 1 10 100 1000])
        set(gca,'YTickLabel',{'0.1', '1', '10', '100', '1000'})
    end
    
    hold on;
    set(gca,'FontSize',14)
    xlabel('Number of Segments');
    ylabel('Runtime in Seconds');
%     grid on;
    axis( [0 2500 0 10000]);
end
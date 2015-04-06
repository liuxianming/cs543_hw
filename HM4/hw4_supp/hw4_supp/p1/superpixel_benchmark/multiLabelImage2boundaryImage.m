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
% boundary_image = multiLabelImage2boundaryImage(mli)
%
% Returns image with ones at all pixel where label in mli is different from
% its right or bottom neighbor, otherwise the image value is zero
%
% mli ... input multi label image
% boundary_image ... output boundary image
%
function boundary_image = multiLabelImage2boundaryImage(mli)

    % right and bottom shift images
    mli_right = mli(:, 1:size(mli,2)-1);
    mli_bottom = mli(1:size(mli,1)-1, :);
    
    % substract
    mli_h_diff = zeros(size(mli));
    mli_v_diff = zeros(size(mli));
    
    mli_h_diff(:,1:size(mli,2)-1)  = (mli_right ~= mli(:, 2:size(mli,2)));
    mli_v_diff(1:size(mli,1)-1, :)  = (mli_bottom ~= mli(2:size(mli,1), :));
    
    boundary_image = (mli_h_diff~=0) | (mli_v_diff~=0);

end
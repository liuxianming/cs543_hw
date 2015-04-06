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
% main_runAffine(bpf_filename)
%
% Run algorithm on transformed images for several affine transformations
% and benchmark
%
% bpf_filename ... input benchmark parameter filename (bpf-file)
%
function main_runAffine(bpf_filename)

    runAlgorithmAffine(bpf_filename, 'apf/apf_translation.txt');
    runBenchmarkAffine(bpf_filename, 'apf/apf_translation.txt');
    
    runAlgorithmAffine(bpf_filename, 'apf/apf_rotation.txt');
    runBenchmarkAffine(bpf_filename, 'apf/apf_rotation.txt');
   
    runAlgorithmAffine(bpf_filename, 'apf/apf_shear.txt');    
    runBenchmarkAffine(bpf_filename, 'apf/apf_shear.txt');

    runAlgorithmAffine(bpf_filename, 'apf/apf_scale.txt');
    runBenchmarkAffine(bpf_filename, 'apf/apf_scale.txt');
    
end
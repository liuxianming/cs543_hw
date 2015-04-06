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
% [undersegError undersegErrorTP undersegErrorSLIC] = getUndersegmentationError(S, GT)
%
% Compute undersegmentation errors described in Turbopixel and SLIC paper
% and the new parameter free version 
%
% S ... input segmentation (multi label image)
% GT ... input ground truth segmentation (multi label image)
%
% undersegError ... (output) proposed undersegmentation error
% undersegErrorTP ... (output) Turbopixel undersegmentation error 
% undersegError ... (output) SLIC undersegmentation error 
%
function [undersegError undersegErrorTP undersegErrorSLIC] = getUndersegmentationError(S, GT)

    % check image sizes
    [hS wS cS] = size(S);
    [hGT wGT cGT] = size(GT);
    if hS~=hGT || wS~= wGT || cS~=1 || cGT~=1
        fprintf('Size error in getUndersegmentationError\n');
        return;
    end

    % segment index should start with 1
    if min(S(:)) == 0
        S=S+1;
    end
    
    % number of segments in S and GT
    nS = double(max(S(:)));
    nGT = double(max(GT(:)));    
    
    % prepare intersection matrix: M(i,j) = overlapping of GT==i and S==j
    % prepare areas of segments of S and GT
    areaS = zeros(nS,1);    
    areaGT = zeros(nGT,1);       
    M = zeros(nGT, nS);
    for y=1:hGT
        for x=1:wGT
            i = GT(y,x);
            j =  S(y,x);
            M(i, j) = M(i,j) + 1;
            areaGT(i) = areaGT(i)+1;
            areaS(j) = areaS(j)+1;
        end
    end
    
    % proposed equation
    sum_undersegError = 0;
    for i=1:nGT
        idx = find(M(i,:));     % index of all non zero entries in this row
        for j=idx
            sum_undersegError = sum_undersegError + min(M(i,j), areaS(j)-M(i,j));            
        end        
    end    
    undersegError = sum_undersegError / numel(GT);  


    % turbopixel equation
    sum_undersegError = 0;
    for i=1:nGT
        sum_covering_sp = 0;
        idx = find(M(i,:));     % index of all non zero entries in this row
        for j=idx
            sum_covering_sp = sum_covering_sp + areaS(j);            
        end
        sum_undersegError = sum_undersegError + (sum_covering_sp-areaGT(i))/areaGT(i);        
    end
    undersegErrorTP = sum_undersegError / nGT;

            
    % SLIC equation
    b=0.05; % minimum overlap is 5%
    sum_undersegError = 0;
    for i=1:nGT
        thresh = b*areaGT(i);
        sum_covering_sp = 0;
        idx = find(M(i,:));     % index of all non zero entries in this row
        for j=idx
            if areaS(j)>thresh
                sum_covering_sp = sum_covering_sp + areaS(j);            
            end
        end
        sum_undersegError = sum_undersegError + sum_covering_sp;        
    end
    undersegErrorSLIC = (sum_undersegError-wS*hS) / (wS*hS);
    
end

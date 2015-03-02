function delta = solveLS(Ix, Iy, It)
%PREDICTTRANSLATION 
% Solve the equation A'A [u,v]' = - b
% And Ix, Iy, It are all colomn vectors

Ix = Ix(:);
Iy = Iy(:);
It = It(:);

H = [Ix'*Ix, Ix' * Iy; Iy' * Ix, Iy' * Iy];
b = -[Ix' * It; Iy' * It];

if abs(det(H)) < 0.01
    % To avoid the singular matrix
    delta = [0,0]';
else
    delta = H\b;
end
end


function [newXs newYs] = predictTranslationAll(startXs, startYs, im0, im1)
%PREDICTTRANSLATIONALL ComputenewX,Y locations for all starting locations.
%   Detailed explanation goes here

P = [0,0];
newP = [startX, startY];
threshold = 0.01;

% The difference between I([x,y] + [u,v], t+1) and I(x, y, t)
delta_p = 100;

while norm(delta_p) > threshold
    % Start tracking
    Ix = wrapping(Ix, P);
    % Calculate the gradient
    It = Iy - Ix;
    
end

% Assign final values
newX = newP(1);
newY = newP(2);


end

